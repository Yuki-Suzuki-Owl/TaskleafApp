class Group < ApplicationRecord
  validates :name,presence:true,uniqueness:true
  has_many :users
  has_many :group_tasks,dependent: :destroy
  has_many :tasks,through: :group_tasks
end
