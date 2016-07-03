class EventsController < ApplicationController
  def index
    @events = events_on_this_date_in_history
    @random_event = random_event_on_this_date_in_history
  end

  private
  include ControllerHelpers
end
