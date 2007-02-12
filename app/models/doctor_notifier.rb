class DoctorNotifier < ActionMailer::Base
  def signup_notification(doctor)
    setup_email(doctor)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://localhost:3000/doctors/activate/#{doctor.activation_code}"
  end
  
  def activation(doctor)
    setup_email(doctor)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://localhost:3000/"
  end
  
  protected
    def setup_email(doctor)
      @recipients  = "#{doctor.email}"
      @from        = "dcparker@gmail.com"
      @subject     = "SixSigma Welcomes You - Continue Registration"
      @sent_on     = Time.now
      @body[:doctor] = doctor
    end
end
