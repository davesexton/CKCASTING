#!/usr/bin/env ruby

#TODO fix load issue
#TODO add output log file
require 'hpricot'
require 'open-uri'
require "net/http"

# ----- Delete images
Dir.chdir('/home/dave/websites/ckcasting/app/assets/images/cast_images')
Dir['*.jpg'].each { |f| File.delete f }

# ----- Set variables
new_id = 1
seed = "# encoding: utf-8\n"

('46'..'600').each do |f|
  doc = Hpricot(open("http://www.ckcasting.co.uk/castbook.aspx?id=#{f}"))

# ----- Get name
  name = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_NAMELabel"]').innerHTML
  next if name == ''
  puts "Found '#{name}' - remapping CAST ID #{f} => #{new_id}"
  last_name = name.match(/\w*$/)[0]
  first_name = name.chomp(last_name).strip

# ----- Get date of birth
  date_of_birth = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HiddenFieldDOB"]').attr(:value)

# ----- Get height
  feet = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HEIGHT_FTLabel"]').innerHTML
  inches = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HEIGHT_INLabel"]').innerHTML

# ----- Get colors
  hair = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HAIR_COLOURLabel"]').innerHTML
  eye = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_EYE_COLOURLabel"]').innerHTML

# ----- Get sex
  sex = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_SEXLabel"]').innerHTML

# ----- Get view counts
  last_viewed = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_LAST_VIEWEDLabel"]').innerHTML
  view_count = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_VIEW_COUNTLabel"]').innerHTML

# ----- Add to seed file
  seed += "Person.create(:first_name => '#{first_name}'" \
   + ", :last_name => '#{last_name}'" \
   + ", :date_of_birth => '#{date_of_birth}'" \
   + ", :height_feet => #{feet}" \
   + ", :height_inches => #{inches}" \
   + ", :hair_colour => '#{hair}'" \
   + ", :eye_colour => '#{eye}'" \
   + ", :gender => '#{sex}'" \
   + ", :last_viewed_at => '#{last_viewed}'" \
   + ", :view_count => #{view_count}" \
   + ", :status => 'Active' )\n"

# ----- Get skills
  ord = 1
  txt = ''
  (doc/'//*[@id="ctl00_MainContentPlaceHolder_InterestsBulletedList"]/li').each do |e|
    txt = e.innerHTML.strip

    seed += "Skill.create(:Person_id => #{new_id}" \
     + ", :display_order => #{ord}" \
     + ", :skill_text => '#{txt}')\n"
    ord += 1
  end

# ----- Get credits
  ord = 1
  txt = ''
  (doc/'//*[@id="ctl00_MainContentPlaceHolder_CreditsBulletedList"]/li').each do |e|
    txt = e.innerHTML.strip
    txt.gsub!('&amp;', 'and')
    txt.gsub!(' The ', ' the ')
    txt.gsub!(' Technicolor ', ' Technicolour ')
    txt.gsub!(/ +/, ' ')
    txt.gsub!(/\.$/, '')
    txt.gsub!(/[']/, '\\\\\'')
    txt.gsub!(/ _ /, ' - ')
    txt.gsub!('Good Night', 'Goodnight')
    txt.gsub!('Kings Head', 'King\\\'s Head')
    txt.gsub!('Drama -TV', 'Drama - TV')
    txt.gsub!(/Sex.+Drugs.+Rock.+Roll/, 'Sex & Drugs & Rock & Roll')
    txt.gsub!('Toonatik TV', 'Toonattik')
    txt.gsub!('Disney Land', 'Disneyland')
    txt.gsub!('W.E ', 'W.E. ')
    txt.gsub!('Kenneth More ', 'Kenneth Moore ')
    txt.gsub!('CBBC- ', 'CBBC - ')

    txt.gsub!(/Paul O.*Grady/, 'Paul O\\\'Grady')

    seed += "Credit.create(:Person_id => #{new_id}" \
     + ", :display_order => #{ord}" \
     + ", :credit_text => '#{txt}')\n"
    ord += 1
  end

# ----- Get image file
  Net::HTTP.start("www.ckcasting.co.uk") do |http|
    resp = http.get("/castbook/#{f}.jpg")
    open("#{new_id}.jpg", "wb") { |file| file.write(resp.body) } if resp.code == '200'

  end

# ----- Next ID
  new_id += 1
end

# ----- Finished
seed.gsub!(':height_feet => ,', ':height_feet => 0,')
seed.gsub!(':height_inches => ,', ':height_inches => 0,')
seed.gsub!('=> ,', '=> nil,')
seed.gsub!("=> '',", '=> nil,')
Dir.chdir('/home/dave/websites/ckcasting/db')
File.open('seeds.rb', "w") { |file| file.write(seed) }
puts " "
puts "Found #{new_id - 1} cast members"
