#!/usr/bin/env ruby

require 'net/http'


Dir.chdir('/home/dave/websites/ckcasting/app/assets/images/cast_images')
('1'..'1000').each { |f| File.delete "#{f}.jpg" if File.exist? "#{f}.jpg" }


new_id = 0
image_count = 0
x = ''
seed = ''
Net::HTTP.start("www.ckcasting.co.uk") do |http|
	('1'..'200').each do |f| 
		
		resp = http.get("/castbook/#{f}.jpg")
		if resp.code == '200'
			body = http.get("/castbook.aspx?id=#{f}").body
			
			if body =~ /Very sorry but/
				puts "Found file #{f}.jpg but no cast details"
				
			else
				# Create seed
				seed += 'Person.create('

				# Get name
				person_name = body.match(/FormViewCastDetails_NAMELabel"\>(.+)\<\/span/)[1]				
				puts "Found #{f}.jpg '#{person_name}' remapping as CAST ID #{new_id += 1}"
				person_last_name = person_name.match(/\w*$/)[0]
				person_first_name = person_name.chomp(person_last_name).strip
				seed += ":first_name => '#{person_first_name}', "
				seed += ":last_name => '#{person_last_name}', "

				# Get height
				height_in = body.match(/FormViewCastDetails_HEIGHT_INLabel"\>(.+)\<\/span/)[1]
				height_ft = body.match(/FormViewCastDetails_HEIGHT_FTLabel"\>(.+)\<\/span/)[1]
				seed += ":height_feet => #{height_ft}, :height_inches => #{height_in}, "

				# Get hair and eye colour
				hair_colour = body.match(/FormViewCastDetails_HAIR_COLOURLabel"\>(.+)\<\/span/)[1]
				eye_colour = body.match(/FormViewCastDetails_EYE_COLOURLabel"\>(.+)\<\/span/)[1]
				seed += ":hair_colour => '#{hair_colour}', :eye_colour => '#{eye_colour}', "

				# Get gender
				gender = body.match(/FormViewCastDetails_SEXLabel"\>(.+)\<\/span/)[1]
				seed += ":gender => '#{gender}', "

				# Get view data
				last_viewed_at = body.match(/FormViewCastDetails_LAST_VIEWEDLabel"\>(.+)\<\/span/)[1]
				view_count = body.match(/FormViewCastDetails_VIEW_COUNTLabel"\>(.+)\<\/span/)[1]
				seed += ":last_viewed_at => '#{last_viewed_at}', :view_count => #{view_count}, "

				seed += ":status => 'Active' ) \n"				
				
				x = body
				#open("#{new_id}.jpg", "wb") { |file| file.write(resp.body) }
				
			end
			image_count += 1
		end
	end
end
puts " "
puts "Found #{image_count} JPGs and #{new_id} cast members"

Dir.chdir('/home/dave/websites/ckcasting/db')
File.open('seeds.rb', "w") { |file| file.write(seed) }
File.open('temp.txt', "w") { |file| file.write(x) }
puts x
# FormViewCastDetails_NAMELabel">Delilah Gendler</span>
