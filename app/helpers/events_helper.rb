module EventsHelper
  def todays_formatted_date_no_year
    Time.now.strftime("%B %d")
  end
end
