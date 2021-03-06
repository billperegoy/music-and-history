# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include Clearance::Controller
    include Clearance::Authentication
    before_filter :authenticate_admin

    LEGAL_USERS = ['bill@peregoy.org', 'annie@stodgy.com', 'musihist@gmail.com']

    def authenticate_admin
      require_login && LEGAL_UUSERS.includes?(logged_in_user)
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end

  def logged_in_user
    current_user.email
  end
end
