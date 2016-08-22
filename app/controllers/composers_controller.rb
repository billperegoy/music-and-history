class ComposersController < ApplicationController
  def index
    @random_event = random_event_on_this_date_in_history
    @composers = Composer.all.order(last_name: :asc, first_name: :asc)
  end

  def show
    @random_event = random_event_on_this_date_in_history
    @composer = Composer.find(params[:id])
  end
end
