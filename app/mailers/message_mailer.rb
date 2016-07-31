class MessageMailer < ActionMailer::Base

  default from: "noreply@musicandhistory.com"
  default to: "bill@peregoy.org"

  def new_message(message)
    @message = message

    mail subject: "Message from #{message.name}"
  end

end
