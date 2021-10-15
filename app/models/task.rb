class Task < ApplicationRecord
  validates :title,presence:true,length:{minimum:2,maximum:30}
  # ,uniqueness:true
  validate :title, :uniqueness_user_in_task
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

  private
  def uniqueness_user_in_task
    # title.include?("")
    user = User.find_by(id:user_id)
    # user = User.fid(id:self.user_id)
    if user.nil?
      errors.add(:user_id,"user need")
    else
      user.tasks.each do |user_task|
        if user_task.id =! self.id
          if user_task.title == self.title
            errors.add(:title,"title must be unique")
          end
        end
      end
    end
  end
end
