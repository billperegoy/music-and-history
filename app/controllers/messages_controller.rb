class MessagesController < ApplicationController
  def new
    @random_event = random_event_on_this_date_in_history
    @message = Message.new
  end

  def create
    @random_event = random_event_on_this_date_in_history
    @message = Message.new(message_params)

    if @message.valid?
      MessageMailer.new_message(@message).deliver
      redirect_to contact_path, notice: "Your message has been sent."
    else
      flash[:alert] = "An error occurred while delivering this message."
      render :new
    end
  end

private
  include ControllerHelpers

  def message_params
    params.require(:message).permit(:name, :email, :content)
  end

end
