#  Table name: users
      #t.string :username, :nickname
      #t.string :password_salt, :password_hash, :limit => 40
      #t.timestamps
      #t.datetime :last_login_at, :last_seen_at
      #t.string :token
      #t.datetime :token_expires_at
      #t.boolean :admin, :activated, :default => false
      #t.string :email
      #t.text :biography

require 'digest/sha1'

class User < ActiveRecord::Base

  attr_accessor   :password
  # Protect internal methods from mass-update with update_attributes
  attr_accessible :username, :nickname, :password, :password_confirmation, :email, :biography

  with_options :if => :password_required? do |u|
    u.validates_presence_of     :password, :password_confirmation
    u.validates_length_of       :password, :within => 6..12, :allow_nil => true
    u.validates_confirmation_of :password, :on => :create
    u.validates_confirmation_of :password, :on => :update, :allow_nil => true
  end

  validates_presence_of     :username, :email
  validates_uniqueness_of   :username, :email, :case_sensitive => false
  validates_uniqueness_of   :nickname, :case_sensitive => false, :allow_nil => true
  validates_length_of       :username, :within => 3..20
  validates_format_of       :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  before_validation { |u| u.nickname = u.username if u.nickname.blank? }

  before_create { |u| u.admin = u.activated = true if User.count == 0 }

  before_save :encrypt_password

  # Authenticates a user by their username and unencrypted password.
  # Returns the user or nil.
  def self.authenticate(username, password, activated=true)
    u = find(:first, :conditions => ["username = ? and activated IS TRUE", username])
    #u = User.find_by_username(username)
    u && u.authenticated?(password, u.password_salt) ? u : nil
  end

  def authenticated?(pass, salt)
    password_hash == User.encrypt(pass, salt)
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.token_expires_at = 2.weeks.from_now.utc
    self.token = User.random_string
    self.last_login_at = Time.now
    save(false)
  end

  def forget_me
    self.token_expires_at = nil
    self.token = nil
    save(false)
  end

  protected

    def password_required?
      password_hash.blank? || !password.blank?
    end

    def encrypt_password
      return if password.blank?
      self.password_salt = User.random_string
      self.password_hash = User.encrypt(password, password_salt)
    end

    # Apply SHA1 encryption to the supplied password.
    # We surround the password with a salt for additional security.
    def self.encrypt(pass, salt)
      Digest::SHA1.hexdigest("--#{pass}::#{salt}--")
    end

    # Generate a random string consists of strings and digits
    def self.random_string
      [Array.new(30){rand(256).chr}.join].pack("m").chomp
    end

end
