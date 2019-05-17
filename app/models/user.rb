class User < ApplicationRecord
attr_accessor :remember_token, :activation_token
before_save :downcase_mail
before_create :create_activation_digest

  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                                    format: {with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i},
                                    uniqueness: {case_sensitive: false}

has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
def User.new_token
  SecureRandom.urlsafe_base64
end

def activate
  # update_attribute(:activated, true)
  # update_attribute(:activated_at, Time.zone.now)
  update_columns(activated: true, activated_at: Time.zone.now)
end

def send_activation_email
  UserMailer.account_activation(self).deliver_now
end

# Remembers a user in the database for use in persistent sessions.
def remember
  self.remember_token = User.new_token
  update_attribute(:remember_digest, User.digest(remember_token))
end

def forget
  update_attribute(:remember_digest, nil)
end

# Returns true if the given token matches the digest.
def authenticated?(attribute, token)
  digest = send("#{attribute}_digest")
  return false if digest.nil?
  BCrypt::Password.new(digest).is_password?(token)
end

private

def downcase_mail
  self.email.downcase!
end

# Creates and assigns the activation token and digest.
 def create_activation_digest
   self.activation_token  = User.new_token
   self.activation_digest = User.digest(activation_token)
 end

end

#  [\w\.\-]+[@][\w\.\-]+[.]\w+
