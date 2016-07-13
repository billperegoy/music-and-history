module EventsHelper
  def todays_formatted_date_no_year
    formatted_date_no_year(Time.now)
  end

  def formatted_date_no_year(date)
    date.strftime("%B %d")
  end

  def formatted_date(date)
    date.strftime("%B %d, %Y")
  end

  def event_icon_for_category(name)
    case name
    when "birth"
      "birth-icon.png"
    when "death"
      "death-icon.png"
    when "performance"
      "performance-icon.png"
    else
      "event-icon.png"
    end
  end

  def event_page_title
    params[:search] || "Today in History: #{todays_formatted_date_no_year}"
  end
end
