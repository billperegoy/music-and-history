module ComposersHelper
  def full_name(composer)
    "#{composer.last_name}, #{composer.first_name}"
  end
end
