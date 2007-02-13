require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :username, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :username,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :username, :email, :case_sensitive => false
  before_save :encrypt_password
  before_create :make_activation_code 
  
  # Activates the user in the database.
  def activate
    @activated = true
    self.attributes = {:activated_at => Time.now.utc, :activation_code => nil}
    save(false)
  end

  def domain
    self.doctor.url_name
  end
  
  def doctor
    Doctor.find_by_id(self.business_id)
  end

  def activated?
    !! activation_code.nil?
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end 
  # Authenticates a user by their username and unencrypted password.  Returns the user or nil.
  def self.authenticate(username, password, doctor)
    return nil if !username || !password || !doctor
#    u = find :first, :conditions => ['username = ? and activated_at IS NOT NULL', username] # need to get the salt
    doc = Doctor.find_by_url_name(doctor)
    return nil if doc.nil?
    u = find :first, :conditions => ['username = ? and business_id = ?', username, doc.id] # :first, :conditions => ['username = ?', username] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end

    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end 
end
