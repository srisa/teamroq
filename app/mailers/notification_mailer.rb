class NotificationMailer < ActionMailer::Base
  default :from => "notifications@example.org"
  
  def send_notification_email(subject,activity,email)
    if NOTIFICATION_EMAIL_ON
      @activity = activity
      mail(to: email, :subject => subject)
    end
  end
end
