class Doctor < ActiveRecord::Base
  has_many :users

  validates_presence_of :alias

end
