require 'csv'
require 'textractor'
require 'docx/html'
require 'nokogiri'

def create_resources_page
  file_name = "db/musicandhistory/resources.docx" 
  doc = Docx::Document.open(file_name)
  html_doc = Nokogiri::HTML(doc.to_html)
  nodes = html_doc.xpath("//p")
  text = nil
  nodes.each do |node|
    if text
      Resource.create(text: text.gsub(/ \./, '.'))
    end
    text = ""
    node.children.each do |child|
      filtered_node_text = filter_node(child)
      text += "#{filtered_node_text} "
    end
  end
  Resource.create(text: text.gsub(/ \./, '.'))
end

def create_about_page
  name = "about"
  content = <<EOM
<p>
Within these pages, important musical events over the last 250 years are listed chronologically along with general historical events. We pay homage to the fact that composers live in the world. They affect the world and are affected by it. If one reads any of these files for any length, one can understand how the music being produced fits within the culture and historical period.music relative to world history.
</p>

<p>
This survey begins in 1752. That was the year that the British Empire converted to the Gregorian calendar. Before this, being sure about a specific date is very difficult. Many authors do not seem to know that there were different calendars between Britain and the Continent. Others do not seem to care. That problem also applies to Russia which did not convert to the Gregorian calendar until 1918; but we have tried to compensate for that. If you spot a Russian event on the wrong date, please let us know.
</p>

<p>
We have attempted to place everything in the Gregorian calendar. Dates are according to local time. (This can sometimes be confusing. For instance, the Japanese attack on Malaya on December 8, 1941 actually happened before their attack on Pearl Harbor on December 7, 1941.) Some attempt has been made to keep the chronological order for multiple items within one date, but this is next to impossible to ensure.
</p>

<p>
Some caveats apply:
</p>

<ol>
<li>
If you find a mistake, or if you see things that seem contradictory, please contact us and gently point it out. Please cite specific scholarly sources for any correction you wish to suggest.
</li>
<li>
The focus in the early decades is euro-centric, in music and history. As western art music took in more and more non-western sources, the focus begins to spread out to encompass the entire planet.
</li>
<li>
No historical events are included for the last ten years.
</li>
</ol>

<p>
Let us know if you find this site useful. We would like to hear all constructive comments.
</p>
EOM

  page = Page.create(name:name, content:content)
  PagePhoto.create(image: "prokofiev1918.jpg", caption: "Sergei Prokofiev in New York, 1918", page_id: page.id)
  PagePhoto.create(image: "nicholas1917.jpg", caption: "Czar Nicholas II of Russia after his abdication in 1917", page_id: page.id)
end


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

  return category_lookup[:event]
end

def process_event(date, description, category_lookup, composer_lookup, composer_aliases, composer_last_name_counts)
  composers = []
  last_names_matched = []
  description = description.gsub(/ ,/, ',')


  # First look for complete first/last name matches
  composer_lookup.each do |composer|
    name = "#{composer[:first_name]} #{composer[:last_name]}"
    regexp = Regexp.new(name)
    if description.match(regexp)
      last_names_matched << composer[:last_name]
      composers << composer[:id]
      description = description.sub(regexp, "<a href=\"/composers/#{composer[:id]}\">#{name}<\/a>")
    end
  end

  # Use any aliases
  # FIXME
  composer_aliases.each do |name, composer_id|
    regexp = Regexp.new(name)
    if description.match(regexp)
      composers << composer_id
      description = description.sub(regexp, "<a href=\"/composers/#{composer_id}\">#{name}<\/a>")
    end
  end

  # Now associate any last name mentions as best as is possible
  composer_last_name_counts.each do |last_name, info|
    if info[:count] == 1 && !last_names_matched.include?(last_name)
      regexp = Regexp.new("#{last_name} \\(")
      sub_regexp = Regexp.new("#{last_name}")
      if description.match(regexp)
        composers << info[:id]
        description = description.sub(sub_regexp, "<a href=\"/composers/#{info[:id]}\">#{last_name}<\/a>")
      end
    end
  end

  category = categorize_description(description, category_lookup)
  eventpic = nil
  event_caption = nil
  #eventpic = (rand(2) == 0) ? nil : "eventpicture-thumb.png"
  #event_caption = eventpic ? "A caption" : nil
  if date == nil
    date = "January 1 1925"
    puts "Error: nil date being added -- #{description}"
  end
  xxx = description.match(/1 January 1925/)
  if xxx
    description = xxx.post_match
  end
  event = Event.create({date: date, category_id: category, description: description, image: eventpic, caption: event_caption})
  composers.each do |composer|
    EventComposerConnector.create(event_id: event.id, composer_id: composer) 
  end

end


def process_month_file(file_name, category_lookup, composer_lookup, composer_aliases, composer_last_name_counts)
  doc = Docx::Document.open(file_name)
  html_doc = Nokogiri::HTML(doc.to_html)
  nodes = html_doc.xpath("//p")

  date = nil
  description = ""
  year = 2200
  nodes.each do |node|
    if year == nil
      year = 2200
    end
    skip = 0
    if (year < 1752) && (description != "") && !description.match(/Paul Scharfenberger/)
      process_event(date, description, category_lookup, composer_lookup, composer_aliases, composer_last_name_counts)
    end
    description = ""

    year = nil
    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    first = filter_node(node.children[0])
    second = filter_node(node.children[1])
    match1 = first.match(/^\s*(?<day>\d+)\s+(?<month>\w+)\s+(?<year>\d+)/)
    if match1
      date = "#{match1['month']} #{match1['day']} #{match1['year']}"
      skip = 1
      year = match1['year'].to_i
    else
      match2 = first.match(/^\s*(?<day>\d+)\s+(?<month>\w+)/)
      if first.match(/^\s*(?<day>\d+)\s+(?<month>\w+)/)
        if months.include?(match2['month'])
          skip = 2
          date = "#{match2['month']} #{match2['day']} #{second}"
          year = second.to_i
        end
      end
    end

    node_count = 0
    node.children.each do |child|
      node_count += 1
      if (node_count > skip)
        filtered_node_text = filter_node(child)
        description += " #{filtered_node_text}"
      end
    end
  end
end 

def filter_node(child)
  child.to_s.
    gsub(/\<strong\>/, '').
    gsub(/\<\/strong\>/, '').
    gsub(/\<em\>/, '<i>').
    gsub(/\<\/em\>/, '</i>').
    gsub(/^ */, '').
    gsub(/ *$/, '').
    gsub(/  */, ' ')
end

def process_year_file(file_name, category_lookup, composer_lookup, composer_aliases, composer_last_name_counts)
  doc = Docx::Document.open(file_name)
  html_doc = Nokogiri::HTML(doc.to_html)
  nodes = html_doc.xpath("//p")

  date = nil
  description = ""
  nodes.each do |node|
    skip = 0
    if (description != "") && !description.match(/Paul Scharfenberger/)
      process_event(date, description, category_lookup, composer_lookup, composer_aliases, composer_last_name_counts)
    end
    description = ""

    months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    first = filter_node(node.children[0])
    second = filter_node(node.children[1])
    match1 = first.match(/^\s*(?<day>\d+)\s+(?<month>\w+)\s+(?<year>\d+)/)
    if match1
      date = "#{match1['month']} #{match1['day']} #{match1['year']}"
      skip = 1
    else
      match2 = first.match(/^\s*(?<day>\d+)\s+(?<month>\w+)/)
      if first.match(/^\s*(?<day>\d+)\s+(?<month>\w+)/)
        if months.include?(match2['month'])
          skip = 2
          date = "#{match2['month']} #{match2['day']} #{second}"
        end
      end
    end

    node_count = 0
    node.children.each do |child|
      node_count += 1
      if (node_count > skip)
        filtered_node_text = filter_node(child)
        description += " #{filtered_node_text}"
      end
    end
  end
end 

Hyperlink.delete_all
LinkCategory.delete_all
Category.delete_all
Event.delete_all
Composer.delete_all
ComposerAlias.delete_all
Page.delete_all
Resource.delete_all

create_resources_page

category_birth = Category.create(name: 'birth')
category_death = Category.create(name: 'death')
category_performance = Category.create(name: 'performance')
category_event = Category.create(name: 'event')
category_lookup = {
  birth: category_birth.id,
  death: category_death.id,
  performance: category_performance.id,
  event: category_event.id
}

composer_lookup = []
composer_aliases = {}
composer_last_name_counts = {}
CSV.foreach("db/musicandhistory/composers-annie.csv") do |row|
  first_name = row[0]
  last_name = row[1]
  composer = Composer.create(first_name: first_name, last_name: last_name)
  composer_lookup << {id: composer.id, last_name: last_name,  first_name: first_name}
  if composer_last_name_counts[last_name]
    composer_last_name_counts[last_name] = {count: 2, id: nil}
  else
    composer_last_name_counts[last_name] = {count: 1, id: composer.id}
  end

  # Add composer aliases
  if row.length > 2
    (2..row.length-1).each do |n|
      ComposerAlias.create(name: row[n], composer_id: composer.id)
      composer_aliases[row[n]] = composer.id
    end
  end
end

files = Dir.glob("db/musicandhistory/[0-9]*")
#files = Dir.glob("db/musicandhistory/1959*")
files.each do |file|
  unless file.match(/anniversaries/)
    puts "Processing #{file}"
    process_year_file(file, category_lookup, composer_lookup, composer_aliases, composer_last_name_counts)
  end
end


files = ["january copy.docx",
         "february copy.docx",
         "march copy.docx",
         "april copy.docx",
         "may copy.docx",
         "june copy.docx",
         "july copy.docx",
         "august copy.docx",
         "september copy.docx",
         "october copy.docx",
         "november copy.docx",
         "december copy.docx"
        ]

files.each do |filename|
  file = "db/musicandhistory/#{filename}"
  puts "Processing #{file}"
  process_month_file(file, category_lookup, composer_lookup, composer_aliases, composer_last_name_counts)
end

links = open("db/musicandhistory/LINKS.txt")
category = nil
description = nil
links.readlines.each do |line|
  m = line.match(/description\s+/)
  if m
    description = m.post_match
  end
  m = line.match(/^category\s+/)
  if m
    name = m.post_match
    category = LinkCategory.create(name: name, description: description)
    description = nil
  end

  m = line.match(/^link\s+/)
  if m
    name = m.post_match.sub(/:.*$/, '')
    url = "http://" + m.post_match.sub(/^.*:\s+/, '').sub(/ .*$/, '')
    Hyperlink.create(name: name, url: url, link_category_id: category.id)
  end
end

create_about_page
