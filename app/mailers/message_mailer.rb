class MessageMailer < ActionMailer::Base

  default from: message.name
  #default to: "musihist@gmail.com"
  default to: "bill@peregoy.org"

  def new_message(message)
    @message = message

    mail subject: "Message from #{message.name}"
  end

end
