class EventsController < ApplicationController
  def index
    if events_params[:search]
      @events = Event.search_description(events_params[:search])
    elsif events_params[:start_year]
      @events = Event.date_range(start_date, end_date)
    else
      @events = events_on_this_date_in_history
    end

    @random_event = random_event_on_this_date_in_history
  end

  private
  include ControllerHelpers
  def date_range?
    events_params[:start_year]
  end

  def events_params
    params.permit(:search, :start_year, :start_month, :start_day, :end_year, :end_month, :end_day)
  end

  def start_date
    date_string = events_params[:start_year] + "-" + events_params[:start_month] + "-" + events_params[:start_day]
    Date.parse(date_string)
  end

  def end_date
    #if events_params[:end_date]
    #  Date.parse(events_params[:end_date])
    #else
      start_date
    #end
  end
end
