class BasicForm < ActiveRecord::Base
  has_many :notes, :as => 'form_instance'
  include FormOperations

end
