require 'textractor'

def categorize_description(text)
  m = text.match(/ is born/)
  if m
    words = m.pre_match

    # Get rid of time of birth at front: "08:30"
    words.sub!(/\d{2}:\d{2} /, '')

    # Get rid of "About 12:30."
    words.sub!(/^[^\.]*\./, '')

    return :birth
  end


  m = text.match(/ dies/)
  if m
    composer = m.pre_match
    #puts "--- DIED: #{composer}"
    return :death
  end

  m = text.match(/ performs/) || text.match(/ is performed/)
  if m
    return :performance
  end

  return :none
end

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
    else
      description = line.gsub(/ +/, ' ');
    end

    category = categorize_description(description)
    #Event.create({date: date, category: category.to_s, description: description})
    Event.create({date: date, description: description})
  end
end 

Category.delete_all
Event.delete_all

Category.create(name: 'birth')
Category.create(name: 'death')
Category.create(name: 'performance')
Category.create(name: 'none')

files = Dir.glob("/Users/bill/Dropbox/musicandhistory/[0-9]*")
files.each do |file|
  unless file.match(/anniversaries/)
    puts "Processing #{file}"
    process_file(file)
  end
end
