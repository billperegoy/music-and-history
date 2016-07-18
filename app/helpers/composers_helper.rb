module ComposersHelper
  def full_name(composer)
    "#{composer.last_name}, #{composer.first_name}"
  end

  def composer_link(composer)
    if composer.events.any?
      link_to full_name(composer), composer
    else
      full_name(composer)
    end
  end

  def composer_columns(groups)
    [
      composer_column(groups, ('A'..'L')),
      composer_column(groups, ('M'..'Z'))
    ]
  end

  def composer_column(groups, range)
    column = {}
    range.each do |letter|
      column[letter] = groups[letter]
    end
    column
  end
end
