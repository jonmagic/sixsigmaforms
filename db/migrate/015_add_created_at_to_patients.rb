class AddCreatedAtToPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :created_at,     :datetime
    Patient.find(:all).each do |p|
      p.created_at = 24.hours.ago
      p.save
    end
  end

  def self.down
    remove_column :patients, :created_at
  end
end
