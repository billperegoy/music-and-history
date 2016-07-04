class EventsController < ApplicationController
  def index
    if params[:search]    
      @events = Event.search_description(params[:search])
    else
      @events = events_on_this_date_in_history
    end

    @random_event = random_event_on_this_date_in_history
  end

  private
  include ControllerHelpers
end
