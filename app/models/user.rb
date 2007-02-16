require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :doctor
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :email, :doctor_id, :friendly_name
  validates_length_of       :email, :within => 3..100
  validates_uniqueness_of   :email, :case_sensitive => false

#[username, password, password_confirmation] are required on user create or any type of password update.
  validates_length_of       :username, :within => 3..40,         :if => :login_change?
  validates_uniqueness_of   :username, :case_sensitive => false, :if => :login_change?
  validates_length_of       :password, :within => 4..40,         :if => :login_change?
  validates_presence_of     :password_confirmation,              :if => :login_change?
  validates_confirmation_of :password,                           :if => :login_change?

  before_save               :encrypt_password
  before_create             :make_activation_code 
  
  # Activates the user in the database.
  def activate
    @activated = true
    self.attributes = {:activated_at => Time.now.utc, :activation_code => nil}
    save(false)
  end

  def activated?
    !! activation_code.nil?
  end

  def domain
    self.doctor.alias
  end
  
  def is_doctor
    self.doctor.alias == self.username
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end 
  # Authenticates a user by their username and unencrypted password.  Returns the user or nil.
  def self.authenticate(username, password, doc_alias)
    return nil if !username || !password || !doc_alias
#    u = find :first, :conditions => ['username = ? and activated_at IS NOT NULL', username] # need to get the salt
    u = find :first, :conditions => ['username = ? and doctor_id = ?', username, Doctor.id_of_alias(doc_alias)] # :first, :conditions => ['username = ?', username] # need to get the salt
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

  def changing_login
    @login_change = true
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{username}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def login_change?
      @login_change
    end
    
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end 
end
