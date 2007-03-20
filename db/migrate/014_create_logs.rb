class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.column :created_at,   :datetime
      t.column :log_type,     :string #Summary, such as "status update" or "modification". the Data field will store the actual status update or modification
      t.column :data,         :string #YAML hash
    end
  end

  def self.down
    drop_table :logs
  end
end
