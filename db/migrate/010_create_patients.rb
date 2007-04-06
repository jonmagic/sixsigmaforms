class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.column :doctor_id,                          :integer
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

      t.column :provider_name,                      :string
      t.column :referring_provider_name,            :string
      t.column :location,                           :string  #Virtual Enum: Office, Inpatient, Outpatient, Other (explain)

      t.column :authorization_number,               :string

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
  end

  def self.down
    drop_table :patients
  end
end
