class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, confirmation: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  before_create :generate_api_key

  private

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end
