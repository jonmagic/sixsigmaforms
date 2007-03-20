class FormType < ActiveRecord::Base
  serialize :required_fields, Array
  has_many :form_instances
  has_and_belongs_to_many :doctors

  after_create   :log_create
  after_update   :log_update
  before_destroy :log_destroy

  validates_presence_of :friendly_name, :name

  def self.model_for(name)
    FormType.find_by_name(name).nil? ? nil : name.constantize
  end

  def the_model
    self.name.constantize
  end

  private
    def log_create
      Log.create(:log_type => 'create:FormType', :data => {})
    end
    def log_update
      Log.create(:log_type => 'update:FormType', :data => {})
    end
    def log_destroy
      Log.create(:log_type => 'destroy:FormType', :data => {})
    end

end
