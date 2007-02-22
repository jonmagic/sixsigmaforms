class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.column :doctor_id,                   :integer
      t.column :insurance_type,              :string   #CMS 1a   #Virtual Enum: Medicare, Medicaid, Champus, ChampVa, Group Health Plan, Feca Blk Lung
      t.column :insurance_id_number,         :string   #CMS 1b
      t.column :last_name,                   :string   #CMS 2a
      t.column :first_name,                  :string   #CMS 2b
      t.column :middle_initial,              :string   #CMS 2c
      t.column :birth_date,                  :date     #CMS 3a
      t.column :sex,                         :string   #CMS 3b   #Virtual Enum: Male, Female
      t.column :insured_first_name,          :string   #CMS 4a
      t.column :insured_middle_initial,      :string   #CMS 4b
      t.column :insured_last_name,           :string   #CMS 4c
      t.column :address,                     :string   #CMS 5a
      t.column :city,                        :string   #CMS 5b
      t.column :state,                       :string   #CMS 5c
      t.column :zipcode,                     :string   #CMS 5d
      t.column :telephone,                   :string   #CMS 5e
      t.column :relationship_to_insured,     :string   #CMS 6    #Virtual Enum: Self, Spouse, Child, Other
      t.column :insured_address,             :string   #CMS 7a
      t.column :insured_city,                :string   #CMS 7b
      t.column :insured_state,               :string   #CMS 7c
      t.column :insured_zipcode,             :string   #CMS 7d
      t.column :insured_telephone,           :string   #CMS 7e
      t.column :marital_status,              :string   #CMS 8a   #Virtual Enum: Single, Married, Other
      t.column :work_status,                 :string   #CMS 8b   #Virtual Enum: Employed, Full-Time Student, Part-Time Student
      t.column :work_accident,               :boolean  #CMS 10a
      t.column :auto_accident,               :boolean  #CMS 10b
      t.column :auto_accident_state,         :string   #CMS 10b-a
      t.column :other_accident,              :boolean  #CMS 10c
      t.column :insured_policy_group_feca_number, :string   #CMS 11-a
      t.column :insured_birth_date,          :date     #CMS 11a-a
      t.column :insured_sex,                 :string   #CMS 11a-b  #Virtual Enum: Male, Female
      t.column :insured_employer,            :string   #CMS 11b
      t.column :insured_plan_program_name,   :string   #CMS 11c
      t.column :another_benefit_plan,        :boolean  #CMS 11d
        t.column :other_insured_first_name,          :string   #CMS 9-a
        t.column :other_insured_middle_initial,      :string   #CMS 9-b
        t.column :other_insured_last_name,           :string   #CMS 9-c
        t.column :other_insured_policy_group_number, :string   #CMS 9a
        t.column :other_insured_birth_date,          :date     #CMS 9b-a
        t.column :other_insured_sex,                 :string   #CMS 9b-b
        t.column :other_insured_employer,            :string   #CMS 9c
        t.column :other_insured_plan_program_name,   :string   #CMS 9d
    end
  end

  def self.down
    drop_table :patients
  end
end
