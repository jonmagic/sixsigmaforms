class CreateDoctors < ActiveRecord::Migration
  def self.up
    create_table :doctors do |t|
      t.column :id,                        :integer
      t.column :username,                  :string, :limit => 25
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :key_diff,                  :blob
      t.column :status,                    :string
      t.column :password_change_date,      :string
      t.column :created_at,                :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :business_name,             :string, :limit => 50
      t.column :address,                   :string
      t.column :contact_person,            :string, :limit => 25
      t.column :telephone,                 :string, :limit => 20
#      t.column :alt_telephone,             :string, :limit => 20
#      t.column :fax,                       :string, :limit => 20
#      t.column :practice_type,             :string, :limit => 30
#      t.column :providers,                 :integer
#      t.column :fiscal_end,                :string
#      t.column :tax_id,                    :string
    end
  end

  def self.down
    drop_table :doctors
  end
end
