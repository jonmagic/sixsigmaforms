class AdminNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Continue Registration'
    @body[:url]  = "http://localhost:3000/admins/register?activation_code=#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://localhost:3000/admins/#{user.id}"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "dcparker@gmail.com"
      @subject     = "[SixSigma] "
      @sent_on     = Time.now
      @body[:user] = user
  end
end
