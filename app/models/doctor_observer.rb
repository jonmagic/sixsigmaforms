class DoctorObserver < ActiveRecord::Observer
  observe Doctor

  def after_create(doctor)
    DoctorNotifier.deliver_signup_notification(doctor)
  end

  def after_save(doctor)
    DoctorNotifier.deliver_activation(doctor) if doctor.recently_activated?
  end
end
