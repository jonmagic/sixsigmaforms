class FormInstance < ActiveRecord::Base
  has_many :notes, :dependent => :destroy
  belongs_to :doctor
  belongs_to :patient
  belongs_to :form_type  #Uses column form_type_id
  belongs_to :form_data, :polymorphic => true, :dependent => :destroy #(, :extend => ...)  #Uses columns form_data_type, form_data_id

#Creating a new FormInstance:
#  FormInstance.new(:doctor => Doctor, :user => current_user, :patient => Patient, :form_type => FormType, [[:form_data => AUTO-CREATES NEW]])

# Automagically create the form data record whenever a FormInstance is created, and then automagically destroy it when the FormInstance is destroyed.
# The form data record will always be tied to self.form_data
  def initialize(*args)
    self.form_data.build(args[:form_type].the_model.create) unless args[:form_type].the_model.nil?
    super(*args)
  end

  def status
    self.status_number.number_to_status
  end

  def status=(value)
    self.status_number = value.status_to_number || self.status_number
  end

  # alias_method :vanilla_destroy, :destroy
  # def destroy
  # # Destroy the corresponding form data record
  #   # frm = self.form_type.form_type.constantize.find(self.form_id)
  #   # frm.destroy unless frm.blank?
  # # Destroy the tied patient record if this is the only form attached to the patient
  #   self.patient.destroy if self.patient.form_instances.count == 1
  # # Finally, destroy the FormInstance
  #   return self.vanilla_destroy(*args)
  # end

end
