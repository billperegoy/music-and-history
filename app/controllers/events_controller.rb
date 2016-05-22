class EventsController < ApplicationController
  def index
    @events = events_on_this_date_in_history
    @random_events = random_event_on_this_date_in_history
  end

  private
  def events_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day).order(date: :asc)
  end

  def random_event_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day).order("RANDOM()").limit(1)
  end
end
