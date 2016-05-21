require 'textractor'

def categorize_description(text, category_lookup)
  m = text.match(/ is born/)
  if m
    words = m.pre_match

    # Get rid of time of birth at front: "08:30"
    words.sub!(/\d{2}:\d{2} /, '')

    # Get rid of "About 12:30."
    words.sub!(/^[^\.]*\./, '')

    return category_lookup[:birth]
  end


  m = text.match(/ dies/)
  if m
    return category_lookup[:death]
  end

  m = text.match(/ performs/) || text.match(/ is performed/)
  if m
    return category_lookup[:performance]
  end

  return category_lookup[:none]
end

def process_file(file_name, category_lookup)
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

    category = categorize_description(description, category_lookup)
    Event.create({date: date, category_id: category, description: description})
  end
end 

Category.delete_all
Event.delete_all

category_birth = Category.create(name: 'birth')
category_death = Category.create(name: 'death')
category_performance = Category.create(name: 'performance')
category_none = Category.create(name: 'none')
category_lookup = {
  birth: category_birth.id,
  death: category_death.id,
  performance: category_performance.id,
  none: category_none.id
}

files = Dir.glob("/Users/bill/Dropbox/musicandhistory/[0-9]*")
files.each do |file|
  unless file.match(/anniversaries/)
    puts "Processing #{file}"
    process_file(file, category_lookup)
  end
end
