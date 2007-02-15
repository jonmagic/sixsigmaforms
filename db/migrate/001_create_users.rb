class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :username,                  :string, :limit => 25
      t.column :doctor_id,                 :integer
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :friendlyname,              :string, :limit => 50
      t.column :key_diff,                  :blob
      t.column :status,                    :string
      t.column :password_change_date,      :string
      t.column :created_at,                :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
    end
  end

  def self.down
    drop_table "users"
  end
end
