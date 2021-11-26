require "test_helper"

class GroupTasksTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin_user = users(:sampleuser)
    @other_user = users(:otheruser)
    @admin_task = tasks(:first_task)
    @other_user_task = tasks(:second_task)
    @andere_group = groups(:second_group)
  end

#GroupTask Publidhed Test
  # Invalid Test
  test "need to log in to publish" do
    assert_no_difference "@admin_user.group.tasks.count" do
      post group_tasks_path,params:{task_id:@admin_task.id,group_id:@admin_user.group.id}
    end
    follow_redirect!
    assert_template "sessions/new"
  end

  test "only your task can be published" do
    log_in @other_user
    assert_no_difference "GroupTask.count" do
      post group_tasks_path,params:{task_id:@admin_task.id,group_id:@admin_user.group.id}
    end
    assert_template "tasks/index"
    assert_match "something is wrong!",response.body
    # assert_select "h1","All Tasks"
    # assert_match "All Tasks",response.body
  end

  test "personal tasks can only be published to your group" do
    log_in @other_user
    assert_no_difference "GroupTask.count" do
      post group_tasks_path,params:{task_id:@other_user_task.id,group_id:groups(:second_group).id}
    end
    assert_template "tasks/index"
    assert_match "something is wrong!",response.body
  end

# GroupTask Publidhed Test
  # Valid Test
  test "valid published test,cannot published same task" do
    log_in @other_user
    assert_difference "GroupTask.count",1 do
      post group_tasks_path,params:{task_id:@other_user_task.id,group_id:@other_user.group.id}
    end
    follow_redirect!
    assert_template "tasks/index"
    assert_select "h1","Group Tasks"
    assert_no_match "something is wrong!",response.body

    assert_no_difference "GroupTask.count" do
      assert_raise "ActiveRecord::RecordInvalid" do
        post group_tasks_path,params:{task_id:@other_user_task.id,group_id:@other_user.group.id}
      end
    end
  end

# GroupTask Unpublished Test
  # Invalid Test
  test "need to log in to unpublish" do
    log_in @other_user
    assert_difference "GroupTask.count",1 do
      post group_tasks_path,params:{task_id:@other_user_task.id,group_id:@other_user.group.id}
    end
    other_user_task = GroupTask.find_by(task_id:@other_user_task.id)
    # other_user_task => .task_id
    # other_user_task => .group.id
    # @other_user_task => .task.id
    # @other_user_task => .task.groups_ids [0,1,2,....]

    delete logout_path
    assert_no_difference "GroupTask.count" do
      delete group_task_path(other_user_task),params:{task_id:other_user_task.task_id,group_id:other_user_task.group.id}
    end
  end

# GroupTask Unpublished Test
  # Valid Test
  test "valid unpublished group_task" do
    log_in @admin_user
    assert_difference "GroupTask.count",1 do
      post group_tasks_path(@admin_task),params:{task_id:@admin_task.id,group_id:@admin_user.group.id}
    end

    admin_task = GroupTask.find_by(task_id:@admin_task.id)
    assert_no_difference "Task.count" do
      assert_difference "GroupTask.count",-1 do
        delete group_task_path(admin_task),params:{task_id:admin_task.task_id,group_id:admin_task.group_id}
      end
    end
  end


  test "if you delete the task,it disappears from the group_task" do
    log_in @admin_user
    assert_not @admin_user.group.tasks.include?(@admin_task)
    assert_difference "@admin_user.group.tasks.count",1 do
      post group_tasks_path,params:{task_id:@admin_task.id,group_id:@admin_user.group_id}
    end
    assert @admin_user.group.tasks.include?(@admin_task)
    @admin_task.destroy
    assert_not @admin_user.group.tasks.include?(@admin_task)
  end

  test "task does not disappear even if the group is deleted" do
    # log_in @admin_user

  end
end
