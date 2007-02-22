class Form < ActiveRecord::Base
  has_and_belongs_to_many :doctors

#In each form instance, include thes lines
#  has_many :notes, :as => 'form_instance'
#  include FormOperations
  
end
