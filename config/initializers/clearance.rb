Clearance.configure do |config|
  config.mailer_sender = "reply@example.com"
  Clearance::PasswordsController.layout "sessions"
  Clearance::SessionsController.layout "sessions"
  Clearance::UsersController.layout "sessions"
end
