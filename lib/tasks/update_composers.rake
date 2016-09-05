def get_currently_matched_composers(description)
  match = description.scan(/<a href=\"\/composers\/(\d+)\">[^>]+</)
  if match.length == 0
    []
  else
    match.map {|elem| elem[0].to_i}
  end
end

def build_composer_mapping_list
  composer_map = {}
  Composer.all.each do |composer|
    full_name = "#{composer.first_name} #{composer.last_name}"
    composer_map[full_name] = composer.id
  end

  ComposerAlias.all.each do |composer_alias|
    composer_map[composer_alias.name] = composer_alias.composer_id
  end
  composer_map
end

def look_for_new_matches(description, composer_map, existing_composers)
  new_description = description
  composers_to_map = []
  composer_map.each do |name, id| 
    regexp = Regexp.new(name)
    if new_description.match(regexp)
      unless existing_composers.include?(id)
        puts "Found unmapped composer #{name}"
        composers_to_map << id
        new_description = new_description.gsub(regexp, "<a href=\"/composers/#{id}\">#{name}<\/a>")
      end
    end
  end
  # Get rid of the span put in by cut/paste from Word.
  if new_description.match(/^<span/)
    puts "Before: #{new_description}"
    new_description = new_description.sub(/^<span[^>]*>/, '').sub(/<\/span>/, '')
    puts "After: #{new_description}"
  end
  {description: new_description, composer_ids: composers_to_map}

end

def process_all_events(composer_map)
  event_count = 1
  total_events =  Event.count
  Event.all.each do |event|
    if (event_count % 10000) == 0
      percent_done = (event_count.to_f / total_events.to_f) * 100
      puts "Processing event #{event_count} (#{percent_done.ceil}%)"
    end
  
    # This gets an array of the ids of all matched composers in the event
    existing_composers = get_currently_matched_composers(event.description)
    event_count += 1

    result = look_for_new_matches(event.description, composer_map, existing_composers)
    if result[:description] != event.description
      puts "Performing update"
      event.update(description: result[:description])
      result[:composer_ids].each do |composer_id|
        EventComposerConnector.create(composer_id: composer_id, event_id: event.id)
      end
    end
  end
end

namespace :admin  do
  desc "update composer/event links in db"
  task :update_composers => :environment do
    composer_map = build_composer_mapping_list
    process_all_events(composer_map)
  end
end
