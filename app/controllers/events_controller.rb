class EventsController < ApplicationController
  def index
    if events_params[:search]
      @events = Event.search_description(events_params[:search])
    elsif events_params[:start_date]
      @events = Event.date_range(start_date, end_date)
    else
      @events = events_on_this_date_in_history
    end

    @random_event = random_event_on_this_date_in_history
  end

  private
  include ControllerHelpers

  def events_params
    params.permit(:search, :start_date, :end_date)
  end

  def start_date
    Date.parse(events_params[:start_date])
  end

  def end_date
    if events_params[:end_date]
      Date.parse(events_params[:end_date])
    else
      start_date
    end
  end
end
