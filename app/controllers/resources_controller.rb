class ResourcesController < ApplicationController
  def index
    @random_event = random_event_on_this_date_in_history
    @resources = Resource.all.sort {|a,b| a.sort_order <=> b.sort_order}
  end
end
