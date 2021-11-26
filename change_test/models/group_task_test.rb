require "test_helper"

class GroupTaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @group_task = GroupTask.new(group_id:groups(:first_group).id,task_id:tasks(:first_task).id)
  end

  test "group_task should be valid" do
    assert @group_task.valid?
  end

  test "should be presence group_id" do
    @group_task.group_id = nil
    assert_not @group_task.valid?
  end

  test "should be presence task_id" do
    @group_task.task_id = nil
    assert_not @group_task.valid?
  end
end
