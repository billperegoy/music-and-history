class MessageMailer < ActionMailer::Base

  default from: "noreply@musicandhistory.com"
  default to: "musihist@gmail.com "

  def new_message(message)
    @message = message

    mail subject: "Message from #{message.name}"
  end

end
