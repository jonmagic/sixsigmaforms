class CreateBasicForms < ActiveRecord::Migration
  def self.up
    create_table :basic_forms do |t|
      t.column :doctor_id,                          :integer
      t.column :status,                             :integer, :default => 1

      t.column :account_number,                     :string
      t.column :last_name,                          :string   #CMS 2a
      t.column :first_name,                         :string   #CMS 2b
      t.column :middle_initial,                     :string   #CMS 2c
      t.column :sex,                                :string   #CMS 3b   #Virtual Enum: Male, Female
      t.column :marital_status,                     :string   #CMS 8a   #Virtual Enum: Single, Married, Separated, Divorced, Widowed, Living with someone, Unknown
      t.column :birth_date,                         :date     #CMS 3a
      t.column :social_security_number,             :string             #Validate ###-##-####
      t.column :address,                            :string   #CMS 5a
      t.column :city,                               :string   #CMS 5b
      t.column :state,                              :string   #CMS 5c
      t.column :zipcode,                            :string   #CMS 5d
      t.column :telephone,                          :string   #CMS 5e
      t.column :work_telephone,                     :string
      t.column :work_status,                        :string   #CMS 8b   #Virtual Enum: Employed, Full-Time Student, Part-Time Student
      t.column :employment_school,                  :string

      t.column :responsible_last_name,              :string
      t.column :responsible_first_name,             :string
      t.column :responsible_middle_initial,         :string
      t.column :responsible_birth_date,             :date
      t.column :responsible_social_security_number, :string             #Validate ###-##-####
      t.column :responsible_address,                :string
      t.column :responsible_city,                   :string
      t.column :responsible_state,                  :string
      t.column :responsible_zipcode,                :string
      t.column :responsible_telephone,              :string
      t.column :responsible_work_telephone,         :string
      t.column :responsible_work_status,            :string             #Virtual Enum: Employed, Full-Time Student, Part-Time Student
      t.column :responsible_employment_school,      :string

      t.column :encounter_form_number,              :string
      t.column :provider_name,                      :string
      t.column :referring_provider_name,            :string
      t.column :location,                           :string  #Virtual Enum: Office, Inpatient, Outpatient, Other (explain)

      t.column :accident,                           :string  #Virtual Enum: [nil], Auto, Work, Home, Other Responsible Party, Sporting, Other
      t.column :accident_date,                      :date

      t.column :admit_date,                         :date
      t.column :discharge_date,                     :date
      t.column :onset_date,                         :date
      t.column :last_menstrual_period,              :date

      t.column :authorization_number,               :string
      t.column :new_patient,                        :boolean
      t.column :emergency,                          :boolean
      t.column :anesthesia_start_time,              :datetime
      t.column :anesthesia_stop_time,               :datetime

      t.column :primary_insurance_company,          :string   #CMS 1a   #Virtual Enum: Medicare, Medicaid, Champus, ChampVa, Group Health Plan, Feca Blk Lung
      t.column :primary_address,                    :string   #CMS 7a
      t.column :primary_city,                       :string   #CMS 7b
      t.column :primary_state,                      :string   #CMS 7c
      t.column :primary_zipcode,                    :string   #CMS 7d
      t.column :primary_telephone,                  :string   #CMS 7e
      t.column :primary_first_name,                 :string   #CMS 4a
      t.column :primary_middle_initial,             :string   #CMS 4b
      t.column :primary_last_name,                  :string   #CMS 4c
      t.column :primary_relationship,               :string   #CMS 6    #Virtual Enum: Self, Spouse, Child, Other
      t.column :primary_birth_date,                 :string   #CMS 1b
      t.column :primary_social_security_number,     :string
      t.column :primary_contract_number,            :string
      t.column :primary_plan_number,                :string
      t.column :primary_group_number,               :string

      t.column :secondary_insurance_company,        :string
      t.column :secondary_address,                  :string
      t.column :secondary_city,                     :string
      t.column :secondary_state,                    :string
      t.column :secondary_zipcode,                  :string
      t.column :secondary_telephone,                :string
      t.column :secondary_first_name,               :string
      t.column :secondary_middle_initial,           :string
      t.column :secondary_last_name,                :string
      t.column :secondary_relationship,             :string
      t.column :secondary_birth_date,               :string
      t.column :secondary_social_security_number,   :string
      t.column :secondary_contract_number,          :string
      t.column :secondary_plan_number,              :string
      t.column :secondary_group_number,             :string

      t.column :tertiary_insurance_company,         :string
      t.column :tertiary_address,                   :string
      t.column :tertiary_city,                      :string
      t.column :tertiary_state,                     :string
      t.column :tertiary_zipcode,                   :string
      t.column :tertiary_telephone,                 :string
      t.column :tertiary_first_name,                :string
      t.column :tertiary_middle_initial,            :string
      t.column :tertiary_last_name,                 :string
      t.column :tertiary_relationship,              :string
      t.column :tertiary_birth_date,                :string
      t.column :tertiary_social_security_number,    :string
      t.column :tertiary_contract_number,           :string
      t.column :tertiary_plan_number,               :string
      t.column :tertiary_group_number,              :string

      
    end
   #Also add this form type into the form_types table
    execute 'INSERT INTO form_types(friendly_name, model, required_fields, can_have_notes) VALUES("CMS-1500", "BasicForm", "' + ['doctor_id', 'account_number', 'last_name', 'first_name', 'sex', 'birth_date', 'address', 'city', 'state', 'zipcode', 'encounter_form_number', 'provider_name', 'location', 'admit_date', 'discharge_date', 'new_patient', 'primary_insurance_company', 'primary_relationship', 'primary_contract_number', 'primary_plan_number', 'primary_group_number'].to_yaml + '", 1)'
   #****
  end

  def self.down
    drop_table :basic_forms
   #Remove this form type from the form_types table
    execute 'DELETE FROM form_types WHERE model="BasicForm"'
   #****
  end
end
