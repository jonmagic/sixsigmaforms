class Page < ActiveRecord::Base

  after_create   :log_create
  after_update   :log_update
  before_destroy :log_destroy

  private
    def log_create
      Log.create(:log_type => 'create:Page', :data => {})
    end
    def log_update
      Log.create(:log_type => 'update:Page', :data => {})
    end
    def log_destroy
      Log.create(:log_type => 'destroy:Page', :data => {})
    end

end
