class GroupTask < ApplicationRecord
  belongs_to :group
  belongs_to :task
  # validates :group_id,uniqueness:{scope: :task_id}
end
