#!/usr/bin/env ruby

#TODO add output log file
require 'hpricot'
require 'open-uri'
require "net/http"

# ----- Delete images
`rm ./public/cast_images/*.jpg`
`rm ./public/cast_carousel/*.jpg`
`rm ./public/cast_thumbs/*.jpg`
`rm ./public/family_thumbs/*.jpg`
`rm ./public/family_images/*.jpg`

Dir.chdir('/home/dave/websites/ckcasting/public/cast_images')
#Dir['*.jpg'].each { |f| File.delete f }

# ----- Set variables
new_id = 1

seed = "# encoding: utf-8\n"

('46'..'600').each do |f|
  doc = Hpricot(open("http://www.ckcasting.co.uk/castbook.aspx?id=#{f}"))

# ----- Get name
  name = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_NAMELabel"]').innerHTML
  next if name == ''

  last_name = name.match(/(\w|\/)*$/)[0]
  first_name = name.chomp(last_name).strip

  puts "Found '#{name}' - remapping CAST ID #{f} => #{new_id}"

# ----- Get date of birth
  date_of_birth = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HiddenFieldDOB"]').attr(:value)

# ----- Get height
  feet = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HEIGHT_FTLabel"]').innerHTML
  inches = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HEIGHT_INLabel"]').innerHTML

# ----- Get colors
  hair = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_HAIR_COLOURLabel"]').innerHTML
  eye = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_EYE_COLOURLabel"]').innerHTML

# ----- Get gender
  gender = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_SEXLabel"]').innerHTML

# ----- Get view counts
  last_viewed = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_LAST_VIEWEDLabel"]').innerHTML
  view_count = (doc/'//*[@id="ctl00_MainContentPlaceHolder_FormViewCastDetails_VIEW_COUNTLabel"]').innerHTML

# ----- Add to seed file
  seed += <<HERE
Person.create(id: #{new_id},
  first_name: '#{first_name}',
  last_name: '#{last_name}',
  date_of_birth: '#{date_of_birth}',
  height_feet: #{feet},
  height_inches: #{inches},
  hair_colour: '#{hair}',
  eye_colour: '#{eye}',
  gender: '#{gender}',
  last_viewed_at: '#{last_viewed}',
  view_count: #{view_count},
  status: 'Active')
HERE

# ----- Get skills
  ord = 1
  txt = ''
  (doc/'//*[@id="ctl00_MainContentPlaceHolder_InterestsBulletedList"]/li').each do |e|
    txt = e.innerHTML.strip

    seed += <<HERE
Skill.create(person_id: #{new_id},
  display_order: #{ord},
  skill_text: '#{txt}')
HERE
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

    seed += <<HERE
Credit.create(person_id: #{new_id},
  display_order: #{ord},
  credit_text: '#{txt}')
HERE
    ord += 1
  end

# ----- Get image file
  Net::HTTP.start("www.ckcasting.co.uk") do |http|
    resp = http.get("/castbook/#{f}.jpg")
    open("#{new_id}.jpg", "wb") do |file|
      file.write(resp.body)
    end if resp.code == '200'

  end

# ----- Next ID
  new_id += 1
end

# ----- Finished
seed += <<HERE
x = User.new(name: 'dave', password_digest: BCrypt::Password.create('Psion123'))
x.save(validate: false)

require "fileutils"

fg = Person.where('first_name LIKE ?', '%&%').pluck(:id)
fg.each_with_index do |v, i|
  Family.create(id: i + 1, family_name: Person.find(v).last_name)
  FileUtils.copy './public/cast_images/' + v.to_s + '.jpg',
                 './public/family_images/' + (i + 1).to_s + '.jpg'
  FileUtils.remove './public/cast_images/' + v.to_s + '.jpg'
end

Person.where('first_name NOT LIKE ? ', '%&%').each do |p|
  Person.where('first_name LIKE ? AND last_name LIKE ? ', '%&%', '%' + p.last_name + '%').each do |g|
    p.family_id = Family.where('family_name LIKE ?', "%" + g.last_name + "%").pluck(:id)[0]
    p.save
  end
end
Person.where('first_name LIKE ? ', '%&%').destroy_all

Rails.cache.clear

HERE

seed.gsub!('height_feet: ,', 'height_feet: 0,')
seed.gsub!('height_inches: ,', 'height_inches: 0,')
seed.gsub!(': ,', ': nil,')
seed.gsub!(": '',", ': nil,')
Dir.chdir('/home/dave/websites/ckcasting/db')
File.open('seeds.rb', "w") { |file| file.write(seed) }
puts " "
puts "Found #{new_id - 1} cast members"
