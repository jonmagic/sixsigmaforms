class BasicForm < ActiveRecord::Base
  has_one :form_instance, :as => :form

end
