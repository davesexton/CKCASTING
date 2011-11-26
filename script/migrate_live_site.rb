#!/usr/bin/env ruby

require "net/http"

Dir.chdir('/home/dave/websites/ckcasting/app/assets/images/cast_images')
Dir['*.jpg'].each { |f| File.delete f }

new_id = 0
image_count = 0
x = ''
seed = '# encoding: utf-8\n'
Net::HTTP.start("www.ckcasting.co.uk") do |http|
	('1'..'700').each do |f| 
		
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
				height_in = body.match(/FormViewCastDetails_HEIGHT_INLabel"\>(.*)\<\/span/)[1]
				height_ft = body.match(/FormViewCastDetails_HEIGHT_FTLabel"\>(.*)\<\/span/)[1]
				seed += ":height_feet => #{height_ft}, :height_inches => #{height_in}, "

				# Get hair and eye colour
				hair_colour = body.match(/FormViewCastDetails_HAIR_COLOURLabel"\>(.*)\<\/span/)[1]
				eye_colour = body.match(/FormViewCastDetails_EYE_COLOURLabel"\>(.*)\<\/span/)[1]
				seed += ":hair_colour => '#{hair_colour}', :eye_colour => '#{eye_colour}', "

				# Get gender
				gender = body.match(/FormViewCastDetails_SEXLabel"\>(.*)\<\/span/)[1]
				seed += ":gender => '#{gender}', "

				# Get view data
				last_viewed_at = body.match(/FormViewCastDetails_LAST_VIEWEDLabel"\>(.*)\<\/span/)[1]
				view_count = body.match(/FormViewCastDetails_VIEW_COUNTLabel"\>(.*)\<\/span/)[1]
				seed += ":last_viewed_at => '#{last_viewed_at}', :view_count => #{view_count}, "

				seed += ":status => 'Active' ) \n"
							
				body.gsub!("\r\n"," ")

				body.match(/_InterestsBulletedList"\>(.+?)\/ul/) do |is| 
					c = 1
					unless is == nil
						(is[1].scan(/li\>(.+?)\<\/li\>/)).each do |i| 
							txt = i[0].gsub(/[']/, '\\\\\'').strip
							txt.gsub!(/ +/, ' ')
							txt.gsub!(/&amp;/, 'and')
							seed += "Skill.create(:Person_id => #{new_id}, :display_order => #{c}, :skill_text => '#{txt}')\n"
							c += 1
						end
					end
				end

				body.match(/_CreditsBulletedList"\>(.+?)\/ul/) do |is| 
					c = 1
					unless is == nil
						(is[1].scan(/li\>(.+?)\<\/li\>/)).each do |i| 
							txt = i[0].gsub(/[']/, '\\\\\'').strip
							txt.gsub!(/ +/, ' ')
							txt.gsub!(/&amp;/, 'and')
							txt.gsub!(/Richard 11/, 'Richard II')
							txt.gsub!(/ _ /, ' - ')
							txt.gsub!(/Paul O Grady/, 'Paul O\\\'Grady')
							
							if txt.match(/1939.+Poliakoff Feature Film/)
								txt = '\\\'1939\\\' Poliakoff Feature Film'
							end
							if txt.match(/Oliver.+Theatre Royal/)
								txt = 'Oliver - Theatre Royal'
							end
							if txt.match(/Nine.+Feature Film/)
								txt = 'Nine - Feature Film'
							end

							seed += "Credit.create(:Person_id => #{new_id}, :display_order => #{c}, :credit_text => '#{txt}')\n"
							c += 1
						end
					end
				end
				
				seed.gsub!('=> ,', '=> nil,')
				#x = body
				open("#{new_id}.jpg", "wb") { |file| file.write(resp.body) }
				
			end
			image_count += 1
		end
	end
end
puts " "
puts "Found #{image_count} JPGs and #{new_id} cast members"

Dir.chdir('/home/dave/websites/ckcasting/db')
File.open('seeds.rb', "w") { |file| file.write(seed) }
#File.open('temp.txt', "w") { |file| file.write(x) }
#puts x
# FormViewCastDetails_NAMELabel">Delilah Gendler</span>
