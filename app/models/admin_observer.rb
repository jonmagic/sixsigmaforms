class AdminObserver < ActiveRecord::Observer
  def after_create(user)
    AdminNotifier.deliver_signup_notification(user)
  end

  def after_save(user)
    AdminNotifier.deliver_activation(user) if user.recently_activated?
  end
end
