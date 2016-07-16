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
end
