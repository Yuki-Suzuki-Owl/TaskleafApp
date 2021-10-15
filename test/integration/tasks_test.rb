require "test_helper"

class TasksTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin_user = users(:sampleuser)
    @other_user = users(:otheruser)
    @admin_user_task = tasks(:first_task)
    @other_user_task = tasks(:second_task)
  end

# Task Create Test
  test "login required to create task" do
    get new_task_path
    follow_redirect!
    assert_template "sessions/new"

    assert_no_difference "Task.count" do
      post tasks_path,params:{task:{title:"task",content:"task content",user_id:@other_user.id}}
    end
  end

  test "unable to create task due to lack of input" do
    log_in @other_user
    get new_task_path
    assert_template "tasks/new"
    assert_no_difference "@other_user.tasks.count" do
      post tasks_path,params:{task:{title:"",content:"task content",user_id:@other_user.id}}
    end
    assert_template "tasks/new"
  end

  test "can only create my own tasks" do
    log_in @other_user
    get new_task_path
    assert_template "tasks/new"

    assert_difference "@other_user.tasks.count" do
      assert_no_difference "@admin_user.tasks.count" do
        post tasks_path,params:{task:{title:"Don't do bad things!",content:"Created as your task",user_id:@admin_user.id}}
      end
    end
    follow_redirect!
    assert_template "tasks/index"
  end

  test "user task titles are unique" do
    log_in @other_user
    get new_task_path
    assert_template "tasks/new"

    title = "same title task"; content = "sample task content"
    assert_difference "@other_user.tasks.count",1 do
      post tasks_path,params:{task:{title:title,content:content}}
    end
    follow_redirect!
    assert_template "tasks/index"

    get new_task_path
    assert_template "tasks/new"
    assert_no_difference "@other_user.tasks.count" do
      post tasks_path,params:{task:{title:title,content:content}}
    end
    assert_template "tasks/new"
    log_out

    log_in @admin_user
    get new_task_path
    assert_template "tasks/new"

    assert_difference "@admin_user.tasks.count",1 do
      post tasks_path,params:{task:{title:title,content:content}}
    end
  end

# Task Update Test
  test "inaccessible to other user tasks" do
    log_in @other_user
    assert_raise ActiveRecord::RecordNotFound do
      get edit_task_path(@admin_user_task)
    end

    title = "not changed"; content = "not change content"
    assert_raise ActiveRecord::RecordNotFound do
      patch task_path(@admin_user_task),params:{task:{title:title,content:content}}
    end

    @admin_user_task.reload
    assert_not_equal @admin_user_task.title,title
    assert_not_equal @admin_user_task.content,content
  end

  test "can only access my tasks" do
    log_in @other_user
    get edit_task_path(@other_user_task)
    assert_template "tasks/edit"
    assert_match @other_user_task.title,response.body

    title = "change title"; content = "change content"
    patch task_path(@other_user_task),params:{task:{title:title,content:content,user_id:@admin_user.id}}
    follow_redirect!
    assert flash.any?
    assert_template "tasks/index"

    @other_user_task.reload
    assert_equal @other_user_task.title,title
    assert_equal @other_user_task.content,content
    assert @other_user.tasks.include?(@other_user_task)
  end

# Task Destroy Test
  test "you must be logged in to delete the task" do
    assert_no_difference "Task.count" do
      delete task_path(@other_user_task)
    end
  end

  test "you can only erase your own tasks" do
    log_in @other_user
    assert_no_difference "Task.count" do
      assert_raise ActiveRecord::RecordNotFound do
        delete task_path(@admin_user_task)
      end
    end

    assert_difference "Task.count",-1 do
      delete task_path(@other_user_task)
    end
    follow_redirect!
    assert flash.any?
    assert_template "tasks/index"
  end

end
