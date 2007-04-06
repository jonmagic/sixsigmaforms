class AdminObserver < ActiveRecord::Observer
  def after_create(user)
    UserNotifier.deliver_signup_notification(user)
  end

  def after_save(user)
    UserNotifier.deliver_activation(user) if user.recently_activated? or user.email_changed?
    UserNotifier.deliver_reset_password(user) if user.recently_unactivated?
  end
end
