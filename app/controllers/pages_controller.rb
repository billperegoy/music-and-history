class PagesController < ApplicationController
  def home
    @random_event = random_event_on_this_date_in_history
  end

  def about
    @random_event = random_event_on_this_date_in_history
  end

  def contact
    @random_event = random_event_on_this_date_in_history
  end

  def links
    @random_event = random_event_on_this_date_in_history
  end

  def resources
    @random_event = random_event_on_this_date_in_history
  end


  private
  include ControllerHelpers
end
