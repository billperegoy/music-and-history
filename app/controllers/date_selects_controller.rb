class DateSelectsController < ApplicationController
  def new
    @random_event = random_event_on_this_date_in_history
    @date_select = DateSelect.new
  end

  def create
    @random_event = random_event_on_this_date_in_history
    @date_select = DateSelect.new(date_select_params)

    if @date_select.valid?
      redirect_to events_path(date_select_params)
    else
      flash[:alert] = "Errpr on date select form."
      render :new
    end
  end

private
  include ControllerHelpers

  def date_select_params
    params.require(:date_select).permit(:start_month, :start_day, :start_year,
                                        :end_month, :end_day, :end_year
                                       )
  end
end
