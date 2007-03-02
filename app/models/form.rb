class Form
  def self.find_by_status(status)
    Form.find_by('status', status)
  end
  def self.find_by(field, value)
    BasicForm.find(field => value)
  end
end
