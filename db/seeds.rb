require 'csv'
require 'textractor'

def create_resources_page
  resources = open("db/musicandhistory/resources_list.txt")
  resources.readlines.each do |line|
    begin
    Resource.create(text: line)
    rescue
      # FIXME puts "Bad text: #{line}"
    end
  end
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
Many composers are underrepresented in this survey. Click here to see a list of composers who should have more of their lives and works in these pages. If you know of sources where one may find biographical information, or information on first performances for any of these artists, please contact us. Any source you suggest must have exact dates.
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
  PagePhoto.create(image: "prokofiev1918.jpg", caption: "Sergei Prokofiev</a> in New York, 1918", page_id: page.id)
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
Page.delete_all
Resource.delete_all

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

create_about_page
create_resources_page
