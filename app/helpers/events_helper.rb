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
    if search? 
      params[:search]
    elsif single_day?
      "Date: #{start_date}"
    elsif date_range? 
      "Dates: #{start_date} to #{end_date}"
    else
      "Today in History: #{todays_formatted_date_no_year}"
    end
  end

  private
  def search?
    params[:search]
  end

  def single_day?
    start_date && !end_date
  end
  def date_range?
    start_date && end_date
  end

  def start_date
    params[:start_date]
  end

  def end_date
    params[:end_date]
  end
end
