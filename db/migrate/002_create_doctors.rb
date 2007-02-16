class CreateDoctors < ActiveRecord::Migration
  def self.up
    create_table :doctors do |t|
      t.column :alias,                     :string, :limit => 25
      t.column :friendly_name,             :string, :limit => 50

      t.column :encryption_key,            :blob
      t.column :address,                   :string
      t.column :contact_person,            :string, :limit => 25
      t.column :telephone,                 :string, :limit => 20
      t.column :tax_id,                    :string
#      t.column :alt_telephone,             :string, :limit => 20
#      t.column :fax,                       :string, :limit => 20
#      t.column :practice_type,             :string, :limit => 30
#      t.column :providers,                 :integer
#      t.column :fiscal_end,                :string
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
    end
  end

  def self.down
    drop_table :doctors
  end
end
