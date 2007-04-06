class AddDoctorRegistrationForm < ActiveRecord::Migration
  def self.up
    create_table :account_setups, :force => true do |t|
      t.column :name,                 :string
      t.column :address,              :string
      t.column :telephone_number,     :string
      t.column :fax_number,           :string
      t.column :email,                :string
      t.column :contact_person,       :string
      t.column :contact_telephone,    :string
      t.column :fiscal_year_end,      :string
      t.column :tax_id,               :string
      t.column :print_insurance_info, :boolean
      t.column :insurance_company_name, :string
      t.column :insurance_date_claim, :string
      t.column :insurance_claim,      :string
      t.column :print_procedure_info, :boolean
      t.column :print_procedure_lines, :boolean
      t.column :print_procedure_charge, :boolean
      t.column :transferring_patient_balances, :boolean
      t.column :number_of_months_on_statements, :integer
      t.column :minimum_dollar_amount_for_patient_statements, :integer
      t.column :percent_for_good_faith_payment, :integer
      t.column :statements_below_good_faith, :integer
      t.column :send_patient_statement_if_insurance_received, :boolean
      t.column :send_patient_statement_if_payment_received, :boolean
      t.column :send_patient_statement_if_new_charge_received, :boolean
      t.column :minimum_days_between_statement, :integer
      t.column :charge_finance_charges, :boolean
      t.column :finance_charges_amount, :integer
      t.column :allow_payment_plans, :boolean
      t.column :minimum_patient_payment, :integer
      t.column :acceptable_payment_plan_length_500, :integer #months
      t.column :acceptable_payment_plan_length_1000, :integer
      t.column :acceptable_payment_plan_length_2500, :integer
      t.column :acceptable_payment_plan_length_3000, :integer
      t.column :use_collection_agency, :boolean
      t.column :collection_agency_name, :string
      t.column :collection_address, :string
      t.column :collection_contact, :string
      t.column :collection_telephone, :string
      t.column :when_to_send_to_collection_agency, :string
      t.column :ss_determines_when_collection_agency, :boolean
      t.column :allow_ss_collection_agency, :boolean
      t.column :balance_bill_after_insurance, :boolean
      t.column :file_zero_charges_to_insurance, :boolean
      t.column :receiving_remittances_electronically, :boolean
      t.column :insurance_plans_list_for_adjustment, :string #serialized list
      t.column :ss_assign_patient_account_number, :boolean
      t.column :location_number_prefix, :boolean
      t.column :information_to_track_on_patients, :string #serialized list
      t.column :ss_keep_employer_information, :boolean
      t.column :always_have_referring_physician, :boolean
      t.column :use_free_after_care, :boolean
      t.column :procedures_are_always_done_together, :boolean
      t.column :participating_provider_for_medicare, :boolean
      t.column :participating_provider_for_bluecross, :boolean
      t.column :participating_provider_for_medicaid_state, :boolean
      t.column :participating_provider_for_medicaid_hmos, :string #serialized list
      t.column :participating_provider_for_ppom, :boolean
      t.column :participating_provider_for_aetna, :boolean
      t.column :participating_provider_for_cigna, :boolean
      t.column :participating_provider_for_other, :string #serialized list
      t.column :provider_name,        :string
      t.column :provider_type,        :string
      t.column :provider_ein_number,  :string
      t.column :provider_license_number, :string
      t.column :provider_ids_npi, :string
      t.column :provider_insurance_names, :string #serialized list
      t.column :provider_insurance_pins, :string #serialized list
      t.column :provider_insurance_group_ids, :string #serialized list
      t.column :referrer_names, :string #serialized list
      t.column :referrer_types, :string #serialized list
      t.column :referrer_ein_numbers, :string #serialized list
      t.column :referrer_license_numbers, :string #serialized list
      t.column :referrer_ids_npis, :string #serialized list
      t.column :referrer_insurance_nameses, :string #serialized list of lists
      t.column :referrer_insurance_idses, :string #serialized list of lists
    end
    #Also add this form type into the form_types table
    execute 'INSERT INTO form_types(friendly_name, name, can_have_notes) VALUES("Account Setup", "AccountSetup", 1)'
    #****
  end

  def self.down
     drop_table :account_setups
    #Remove this form type from the form_types table
     execute 'DELETE FROM form_types WHERE name="AccountSetup"'
    #****
  end
end
