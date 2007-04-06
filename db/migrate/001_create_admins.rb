class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table "admins", :force => true do |t|
      t.column :username,                  :string
      t.column :friendly_name,             :string, :limit => 50
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      
      t.column :activation_code, :string, :limit => 40
      t.column :activated_at, :datetime
    end
#Creates a user/pass:  admin/admin, to allow for a login upon app creation.
    execute 'INSERT INTO admins(username, friendly_name, email, crypted_password, salt, created_at, activated_at) VALUES("admin", "Administrator", "master@yanno.org", "0b73f51fe263f2053c223015a8ed678a2d39111b", "1b441d02f043b07276e4f09a8d084254bef8350e", "' + Time.now.to_s + '", "' + Time.now.to_s + '")'
  end

  def self.down
    drop_table "admins"
  end
end
