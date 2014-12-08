class WelcomeMailer < ActionMailer::Base
	default :from => "default@example.org"

  def send_welcome_email email
    mail(to: email,subject: "Welcome to Teamroq!")
  end

  def send_welcome_email_to_user email
    mail(to: email,subject: "Welcome to Teamroq!")
  end

end