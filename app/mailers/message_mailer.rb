class MessageMailer < ActionMailer::Base

  #default to: "musihist@gmail.com"
  default to: "bill@peregoy.org"

  def new_message(message)
    @message = message

    mail subject: "Message from #{message.name}"
    mail from: message.email
  end

end
