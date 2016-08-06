module ControllerHelpers
  def events_on_this_date_in_history(month, day)
    Event.by_month(month).by_day(day).order(date: :asc)
  end

  def random_event_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day).order("RANDOM()").limit(1).first
  end
end
