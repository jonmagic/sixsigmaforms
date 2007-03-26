class Nobody
  def friendly_name
    'Please log in'
  end
  def is_doctor?
    false
  end
  def is_admin?
    false
  end
  def is_doctor_or_admin?
    false
  end
  def is_doctor_user?
    false
  end
  def doctor
    Doctor.new
  end
  def drafts(load=false)
    []
  end
  def submitted(load=false)
    []
  end
  def reviewed(load=false)
    []
  end
  def accepted(load=false)
    []
  end
end
