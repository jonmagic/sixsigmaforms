require 'digest/sha1'
class Doctor < ActiveRecord::Base
  has_many  :users, :dependent => :destroy, :conditions => 'username<>"#{self.alias}"'
  has_one   :admin, :class_name => 'User', :conditions => 'username="#{self.alias}"', :dependent => :destroy
  has_many  :patients, :dependent => :destroy
  has_many  :form_instances, :dependent => :destroy
  has_and_belongs_to_many :form_types

  validates_presence_of     :alias, :friendly_name, :address, :telephone
  validates_length_of       :alias, :within => 5..25
  validates_uniqueness_of   :alias, :case_sensitive => false

  before_create             :make_encryption_key

  def self.form_model(form_type_name)
    type = FormType.find_by_name(form_type_name)
    type.nil? ? nil : type.name.constantize
  end
  #This is the proxy method to the form data records
  def form_model(form_type_name)
    type = FormType.find_by_name(form_type_name)
logger.error "Doctor includes " + (self.form_type_ids.join(', ')) + ", but NOT #{type}?"
    return nil unless self.form_types.include?(type)
    type.nil? ? nil : type.name.constantize
  end

  def self.exists?(doc_alias)
    !Doctor.find_by_alias(doc_alias).blank?
  end

  def self.id_of_alias(doc_alias)
    Doctor.find_by_alias(doc_alias).id
  end

  protected
    def validate_on_create
      errors.add(:alias, "cannot be set to <em>\"#{self.alias}\"</em>. Please choose another alias.") if ['pages', 'login', 'logout', 'manage'].include?(self.alias)
    end

    def validate_on_update
      old_doctor = Doctor.find_by_id(id)

#      if operation == 'activate' #Activate
#        if activation_code_valid
#          errors.add(:username, "can't be blank") if username.blank? && old_user.username.blank?
#          errors.add(:password, "can't be blank") if password.blank? && old_user.crypted_password.blank?
#        else
#          errors.add(:activation_code, "is not valid.") unless @just_activated
#        end
#      else
#        if operation == 'password_change' #Password Change
##Need to add in validations here
#          
#        else #Other Update function: restrain from changing username, password, activation_code (save(false) to inject activation_code)
##Need to add in validations here
#          
#        end
#      end
      if !old_doctor.blank?
        errors.add_to_base("Only SixSigma Admin users can modify your assigned forms.") if !form_type_ids.blank? && !old_doctor.form_type_ids.blank? && !(form_type_ids == old_doctor.form_type_ids)
        errors.add(:alias, "cannot be changed once created!") if !self.alias.blank? && !old_doctor.alias.blank? && !(self.alias == old_doctor.alias)
      end
    end

    def make_encryption_key
      self.encryption_key = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end 

end
