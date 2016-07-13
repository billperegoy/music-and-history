class EventsController < ApplicationController
  def index
    if events_params[:search]
      @events = Event.search_description(events_params[:search])
    else
      @events = events_on_this_date_in_history
    end

    @random_event = random_event_on_this_date_in_history
  end

  private
  include ControllerHelpers

  def events_params
    params.permit(:search)
  end
end
