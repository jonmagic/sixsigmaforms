class Note < ActiveRecord::Base
  belongs_to :form_instance
  belongs_to :author, :polymorphic => true

  after_create   :log_create
  after_update   :log_update
  before_destroy :log_destroy

  private
    def log_create
      Log.create(:log_type => 'create:Note', :data => {})
    end
    def log_update
      Log.create(:log_type => 'update:Note', :data => {})
    end
    def log_destroy
      Log.create(:log_type => 'destroy:Note', :data => {})
    end

end
