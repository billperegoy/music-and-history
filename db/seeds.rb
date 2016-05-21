require 'csv'
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

def process_file(file_name, category_lookup, composer_lookup)
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

    composer_lookup.each do |composer|
      name = "#{composer[:first_name]} #{composer[:last_name]}"
      regexp = Regexp.new(name)
      if description.match(regexp)
        # Can we craete a link here to all of the entries for this composer?
        #puts "Match: #{name}"
        description = description.sub(regexp, "<a href=\"#\">#{name}<\/a>")
        #puts description
      end
    end

    category = categorize_description(description, category_lookup)
    Event.create({date: date, category_id: category, description: description})
  end
end 

Category.delete_all
Event.delete_all
Composer.delete_all

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

composer_lookup = []
CSV.foreach("/Users/bill/Dropbox/musicandhistory/composers-annie.csv") do |row|
  first_name = row[0]
  last_name = row[1]
  composer = Composer.create(first_name: first_name, last_name: last_name)
  composer_lookup << {id: composer.id, last_name: last_name,  first_name: first_name}
end

files = Dir.glob("/Users/bill/Dropbox/musicandhistory/[0-9]*")
files.each do |file|
  unless file.match(/anniversaries/)
    puts "Processing #{file}"
    process_file(file, category_lookup, composer_lookup)
  end
end
