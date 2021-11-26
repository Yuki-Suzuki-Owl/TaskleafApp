class Task < ApplicationRecord
  validates :title,presence:true,length:{minimum:2,maximum:30}
  # ,uniqueness:true
  # validate :title, :uniqueness_user_in_task
  validates :title,uniqueness: {scope: :user_id}
  belongs_to :user
  has_many :group_tasks,dependent: :destroy
  has_many :groups,through: :group_tasks

  def public
    if self.user_id == @current_user&.id
      group = Group.find_by(@current_user.group_id)
      group.tasks << self
    else
      return "'#{self.title}' is not your Task."
    end
    return self.title + "Your Task will be GroupTask!"
  end

  def limit_string
    string = self.content.slice(0,100)
    if string.length != self.content.length
      return string + "....."
    end
    return string
  end

end
