class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://localhost:3000/#{user.domain}/myaccount/register?activation_code=#{user.activation_code}"
  end
  
  def reset_password(user)
    setup_email(user)
    @subject    += 'Please click the link below to reset your password.'
    @body[:url]  = "http://localhost:3000/#{user.domain}/myaccount/register?activation_code=#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://localhost:3000/"
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
