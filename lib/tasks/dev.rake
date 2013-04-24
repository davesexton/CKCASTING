namespace :dev do
  desc "Reseed development database with live data"
  task :reseed, [:name, :password] => :environment do |t, args|

    require 'net/http'
    require 'open-uri'
    require 'hpricot'

    if args.name.nil? || args.password.nil?
      puts "ERROR: Missing or invalid creditials parameter"
      exit
    end

    uri = URI.parse('http://www.ckcasting.co.uk:80/login')
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({name: args.name, password: args.password})

    response = http.request(request)

    cookies  = response.response['set-cookie']

    request = Net::HTTP::Get.new('/backup')
    request['Cookie'] = cookies
    response = http.request(request)

    seed_file = Rails.root.join('db', 'seeds.rb')
    doc = Hpricot(response.body)
    File.open(seed_file, 'w:ASCII-8BIT') {|f| f.write((doc/'/pre').innerHTML)}

    check = `ruby -c #{Rails.root.join('db','seeds.rb')} 2>&1`

    if $?.exitstatus != 0
      puts "ERROR: Invalid seeds.rb file"
      puts check.gsub("\n", '')
      exit
    end

    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    puts "Stsrting database seeding..."
    Rake::Task['db:seed'].invoke
    puts "Database reseeded!"

    puts "Removing cast thumbnail images"
    dir = Rails.root.join('public', 'cast_thumbs')
    Dir["#{dir}/*.jpg"].each{|f| File.delete(f) }

    puts "Removing cast carousel images"
    dir = Rails.root.join('public', 'cast_carousel')
    Dir["#{dir}/*.jpg"].each{|f| File.delete(f) }

    puts "Removing family thumbnail images"
    dir = Rails.root.join('public', 'family_thumbs')
    Dir["#{dir}/*.jpg"].each{|f| File.delete(f) }

    dir = Rails.root.join('public', 'cast_images')

    Person.all.each do |p|

# ----- Get image file
      Net::HTTP.start("www.ckcasting.co.uk") do |http|
        resp = http.get("/cast_images/#{p.id.to_s}.jpg")
        open("#{dir.join(p.id.to_s)}.jpg", "wb") do |file|
          file.write(resp.body)
          puts "Downloading cast image for #{p.full_name} ID: #{p.id.to_s}"
        end if resp.code == '200'
      end

    end

    dir = Rails.root.join('public', 'family_images')

    Family.all.each do |f|

# ----- Get image file
      Net::HTTP.start("www.ckcasting.co.uk") do |http|
        resp = http.get("/family_images/#{f.id.to_s}.jpg")
        open("#{dir.join(f.id.to_s)}.jpg", "wb") do |file|
          file.write(resp.body)
          puts "Downloading family image for #{f.family_name} ID: #{f.id.to_s}"
        end if resp.code == '200'
      end

    end

  end
end
