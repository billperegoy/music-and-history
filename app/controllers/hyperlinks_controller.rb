class HyperlinksController < ApplicationController
  def index
    @random_event = random_event_on_this_date_in_history
    @link_categories = LinkCategory.all
  end
end
