class Form < ActiveRecord::Base
  has_and_belongs_to_many :doctors
  
end
