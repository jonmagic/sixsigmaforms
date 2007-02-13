class CreateDoctors < ActiveRecord::Migration
  def self.up
    create_table :doctors do |t|
      t.column :id,                        :integer
      t.column :url_name,                  :string, :limit => 25
      t.column :key_diff,                  :blob
      t.column :created_at,                :datetime
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
