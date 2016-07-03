class ComposersController < ApplicationController
  def index
    @random_event = random_event_on_this_date_in_history
    @composers = Composer.all
  end

  def show
    @random_event = random_event_on_this_date_in_history
    @composer = Composer.find(params[:id])
  end

  private
  def events_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day).order(date: :asc)
  end

  def random_event_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day).order("RANDOM()").limit(1).first
  end
end
