class Note < ActiveRecord::Base
 #Each type of FormInstance (subclasses of FormInstance) relate back to this via has_many :notes, :as => :form_instance
  belongs_to :form_instance
 #Belongs to Admins and Users as Author. If I'm correct, this will allow me to say Note.author = @admin or Note.author = @user, and it will create the correct author_type and author_id
  belongs_to :author, :polymorphic => true

end
