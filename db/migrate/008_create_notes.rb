class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :form_instance_id,       :integer
#has_one :author polymorphic Admin/User
      t.column :author_type,            :string
      t.column :author_id,              :integer
      t.column :text,                   :text
      t.column :created_at,             :datetime
    end
  end

  def self.down
    drop_table :notes
  end
end
