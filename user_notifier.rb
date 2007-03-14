class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Continue Registration'
    @body[:url]  = "http://0.0.0.0:3000" + myaccount_path(:domain => user.domain, :action => 'register', :activation_code => user.activation_code)
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://0.0.0.0:3000" + myaccount_path(:host => '0.0.0.0', :domain => user.domain)
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
