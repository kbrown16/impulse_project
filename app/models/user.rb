class User < ActiveRecord::Base

  attr_accessor :remember_token

  has_many :videos, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower


  default_scope -> { order(username: :desc) }
  before_save { self.email = email.downcase}

  validates :username, :presence => {:message => "can't be blank."}, :length => {maximum: 50, :message => "must be less than 50 characters."}, :uniqueness => {case_sensitive: false, :message => "already exists." }

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => {:message => "can't be left blank."}, :format => {:with => email_regex}, :uniqueness => {:message => "already used for another account."}

  validates :fname, :presence => {:message => "First name can't be left blank."}, :length => {maximum: 50, :message => "First name must be shorter than 50 characters."}

  validates :lname, :presence => {:message => "Last name can't be left blank."}, :length => {maximum: 50, :message => "Last name must be shorter than 50 characters."}

  validates :location, :presence => {:message => "can't be left blank."}, :length => {maximum: 80, :message => "must be shorter than 80 characters."}

  validates :interests, :presence => {:message => "can't be left blank."}, :length => {maximum: 150, :message => "must be shorter than 150 characters."}

  validates :bio, :presence => {:message => "can't be left blank."}, :length => {maximum: 500, :message => "must be shorter than 500 characters."}


has_secure_password
  validates :password, :presence => {:message => "can't be left blank."}, :length => {minimum: 8, :message => "must be longer than 8 characters."}, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Video.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def self.search(search)
    where("fname LIKE ? OR username LIKE ? OR location LIKE ? ", "%#{search}%", "%#{search}%", "%#{search}%")
end


end
