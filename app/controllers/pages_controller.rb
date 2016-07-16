class PagesController < ApplicationController
  def about
    @random_event = random_event_on_this_date_in_history
    @page = Page.find_by(name: 'about')
  end

  def resources
    @random_event = random_event_on_this_date_in_history
  end

  private
  include ControllerHelpers
end
