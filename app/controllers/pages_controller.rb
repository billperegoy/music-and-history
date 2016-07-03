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
  def events_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day).order(date: :asc)
  end

  def random_event_on_this_date_in_history
    today = Date.today
    Event.by_month(today.month).by_day(today.day).order("RANDOM()").limit(1).first
  end
end
