class MessageMailer < ActionMailer::Base

  default from: "Your Mailer <noreply@musicandhistory.com>"
  default to: "Your Name <hello@musicandhistory.com>"

  def new_message(message)
    @message = message

    mail subject: "Message from #{message.name}"
  end

end
