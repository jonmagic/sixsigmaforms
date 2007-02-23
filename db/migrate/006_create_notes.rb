class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.column :form_type,              :integer
      t.column :form_id,                :integer
      t.column :author_type,            :integer
      t.column :author_id,              :integer
      t.column :text,                   :text
      t.column :created_at,             :datetime
    end
  end

  def self.down
    drop_table :notes
  end
end
