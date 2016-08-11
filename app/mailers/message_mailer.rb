class MessageMailer < ActionMailer::Base

  default to: "musihist@gmail.com"

  def new_message(message)
    @message = message

    mail subject: "Message from #{message.name}"
    mail from: message.email
  end

end
