a = []
Dir.chdir('/home/dave/websites/ckcasting/doc')
Credit.find(:all).each { |f| a.push("#{f.credit_text}\n") }
b = a.sort.uniq.join
File.open('credits.txt', 'w') { |file| file.write(b) }