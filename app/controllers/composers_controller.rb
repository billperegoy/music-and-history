class ComposersController < ApplicationController
  #before_action :require_login
  def index
    @random_event = random_event_on_this_date_in_history
    @composers = Composer.all.includes(:events)
  end

  def show
    @random_event = random_event_on_this_date_in_history
    @composer = Composer.find(params[:id])
  end
end
