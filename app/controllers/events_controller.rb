class EventsController < ApplicationController
  def index
    #@events = events_on_this_date_in_history
    @events = Event.all
  end

  private
  def events_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day)
  end
end
