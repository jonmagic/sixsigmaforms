class FormInstance < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  belongs_to :doctor
  belongs_to :patient
  belongs_to :form_type  # form_type_id
  belongs_to :form, :polymorphic => true #, :extend => ...  #form_type, form_id

  def status
    self.status_number.number_to_status
  end

  def status=(value)
    self.status_number = value.status_to_number || self.status_number
  end

  def destroy
    frm = self.form_type.form_type.constantize.find(self.form_id)
    frm.destroy unless frm.blank?
    super
  end

end
