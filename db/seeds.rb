# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


require 'textractor'

def process_file(file_name)
  x = Textractor.text_from_path(file_name)
  lines = x.split("\n")
  
  date = nil
  lines.each do |line|
    next if line.length == 0
    break if line.match(/Paul Scharfenberger/)
    m = line.match(/^\s*(?<day>\d+)\s+(?<month>\w+)\s+(?<year>\d+)\s+(?<text>.*)$/)
    if m
      date = "#{m['month']} #{m['day']} #{m['year']}"
      description =  m['text'].gsub(/ +/, ' ');
      Event.create({date: date, description: description})
    else
      description =  line.gsub(/ +/, ' ');
      Event.create({date: date, description: description})
    end
  end
end 

Event.delete_all
files = Dir.glob("/Users/bill/Dropbox/musicandhistory/[0-9]*")
files.each do |file|
  unless file.match(/anniversaries/)
    puts "Processing #{file}"
    process_file(file)
  end
end
