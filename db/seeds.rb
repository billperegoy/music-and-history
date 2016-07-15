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

  m = text.match(/ performs/) || text.match(/ is performed/) || text.match(/ performance/) || text.match(/ premier/) || text.match(/ are performed/)
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

    composers = []
    composer_lookup.each do |composer|
      name = "#{composer[:first_name]} #{composer[:last_name]}"
      regexp = Regexp.new(name)
      if description.match(regexp)
        composers << composer[:id]
        description = description.sub(regexp, "<a href=\"/composers/#{composer[:id]}\">#{name}<\/a>")
      end
    end

    category = categorize_description(description, category_lookup)
    eventpic = (rand(2) == 0) ? nil : "eventpicture-thumb.png"
    event_caption = eventpic ? "A caption" : nil
    event = Event.create({date: date, category_id: category, description: description, image: eventpic, caption: event_caption})
    composers.each do |composer|
      EventComposerConnector.create(event_id: event.id, composer_id: composer) 
    end
  end
end 

LinkCategory.delete_all
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
CSV.foreach("db/musicandhistory/composers-annie.csv") do |row|
  first_name = row[0]
  last_name = row[1]
  composer = Composer.create(first_name: first_name, last_name: last_name)
  composer_lookup << {id: composer.id, last_name: last_name,  first_name: first_name}
end

files = Dir.glob("db/musicandhistory/[0-9]*")
files.each do |file|
  unless file.match(/anniversaries/)
    puts "Processing #{file}"
    process_file(file, category_lookup, composer_lookup)
  end
end

links = open("db/musicandhistory/LINKS.txt")
category = nil
links.readlines.each do |line|
  m = line.match(/^category\s+/)
  if m
    name = m.post_match
    category = LinkCategory.create(name: name)
  end

  m = line.match(/^link\s+/)
  if m
    name = m.post_match.sub(/:.*$/, '')
    url = "http://" + m.post_match.sub(/^.*:\s+/, '').sub(/ .*$/, '')
    Hyperlink.create(name: name, url: url, link_category_id: category.id)
  end
end
