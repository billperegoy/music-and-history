class PagesController < ApplicationController
  def about
    @random_event = random_event_on_this_date_in_history
  end

  def resources
    @random_event = random_event_on_this_date_in_history
  end

  private
  include ControllerHelpers
end
