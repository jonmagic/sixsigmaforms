class Patient < ActiveRecord::Base
  belongs_to :doctor
  has_many :form_instances, :dependent => :destroy
  has_many :drafts, :class_name => 'FormInstance', :conditions => "status_number=1"

  attr_accessible :doctor, :doctor_id, :account_number, :last_name, :first_name, :middle_initial, :sex
  attr_accessible :marital_status, :birth_date, :social_security_number, :address, :city, :state
  attr_accessible :zipcode, :telephone, :work_telephone, :work_status, :employment_school
  attr_accessible :provider_name, :referring_provider_name, :location, :authorization_number
  attr_accessible :primary_insurance_company, :primary_address, :primary_city, :primary_state, :primary_zipcode, :primary_telephone, :primary_first_name, :primary_middle_initial, :primary_last_name, :primary_relationship, :primary_birth_date, :primary_social_security_number, :primary_contract_number, :primary_plan_number, :primary_group_number
  attr_accessible :secondary_insurance_company, :secondary_address, :secondary_city, :secondary_state, :secondary_zipcode, :secondary_telephone, :secondary_first_name, :secondary_middle_initial, :secondary_last_name, :secondary_relationship, :secondary_birth_date, :secondary_social_security_number, :secondary_contract_number, :secondary_plan_number, :secondary_group_number
  attr_accessible :tertiary_insurance_company, :tertiary_address, :tertiary_city, :tertiary_state, :tertiary_zipcode, :tertiary_telephone, :tertiary_first_name, :tertiary_middle_initial, :tertiary_last_name, :tertiary_relationship, :tertiary_birth_date, :tertiary_social_security_number, :tertiary_contract_number, :tertiary_plan_number, :tertiary_group_number

  def find_best_identifier
    self.first_name.length > 1 ? (self.last_name.length > 1 ? "#{self.last_name}, #{self.first_name}" : (self.account_number.length > 1 ? "#{self.first_name}, ##{self.account_number}" : self.first_name)) : (self.last_name.length > 1 ? (self.account_number.length > 1 ? "#{self.last_name}, ##{self.account_number}" : "#{self.last_name}") : (self.account_number.length > 1 ? "patient ##{self.account_number}" : "(new patient)"))
  end

end
