module ComposersHelper
  def full_name(composer)
    if composer.first_name
      "#{composer.last_name}, #{composer.first_name}"
    else
      "#{composer.last_name}"
    end
  end

  def composer_link(composer)
    link_to full_name(composer), composer
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
