require 'digest/sha1'
class Doctor < ActiveRecord::Base
  has_many  :users
  has_many  :patients
  has_and_belongs_to_many  :forms

  validates_presence_of     :alias, :friendly_name, :address, :telephone
  validates_length_of       :alias, :within => 5..25
  validates_uniqueness_of   :alias, :case_sensitive => false

  before_create             :make_encryption_key

  def admin
    User.find_by_username(self.alias)
  end

  def self.exists?(doc_alias)
    !Doctor.find_by_alias(doc_alias).blank?
  end

  def self.id_of_alias(doc_alias)
    Doctor.find_by_alias(doc_alias).id
  end

  protected
    def make_encryption_key
      self.encryption_key = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end 

end
