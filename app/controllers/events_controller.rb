class EventsController < ApplicationController
  def index
    if events_params[:search]
      @events = Event.search_description(events_params[:search])
    elsif events_params[:start_year]
      if date_range?
        @events = Event.date_range(start_date, end_date)
      else
        if events_params[:start_year] == ""
          @events = events_on_this_date_in_history(start_date.month, start_date.day)
        else
          @events = Event.date_range(start_date, start_date)
        end
      end
    else
      today = Date.today
      @events = events_on_this_date_in_history(today.month, today.day)
    end

    @random_event = random_event_on_this_date_in_history
  end

  private
  def date_range?
    events_params[:date_range] == "1"
  end

  def events_params
    params.permit(:search, :start_year, :start_month, :start_day, :end_year, :end_month, :end_day, :date_range)
  end

  def start_date
    date_string = "#{events_params[:start_year]}-#{events_params[:start_month]}-#{events_params[:start_day]}"
    Date.parse(date_string)
  end

  def end_date
    date_string = "#{events_params[:end_year]}-#{events_params[:end_month]}-#{events_params[:end_day]}"
    Date.parse(date_string)
  end
end
