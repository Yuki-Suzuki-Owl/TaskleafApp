class User < ApplicationRecord
  validates :name,presence:true
  validates :email,presence:true,uniqueness:true
  validates :password,presence:true,length:{minimum:6},allow_nil:true
  has_secure_password
  has_many :tasks,dependent: :destroy
  belongs_to :group

  # Minitest
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string,cost:cost)
  end
end
