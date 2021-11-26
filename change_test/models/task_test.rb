require "test_helper"

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    title = "test task"
    content = "this is first task."
    @user = users(:sampleuser)
    @user_task = @user.tasks.new(title:title,content:content)
    @other_user = users(:otheruser)
  end

  test "task should be valid" do
    assert @user_task.valid?
  end

  test "user should be require" do
    @user_task.user = nil
    assert_not @user_task.valid?
  end

  test "title should be require" do
    @user_task.title = ""
    assert_not @user_task.valid?
  end

  test "title should be length minimum 2" do
    @user_task.title = "a"
    assert_not @user_task.valid?
  end

  test "title should be unique" do
    @user_task.save
    other_task = @user.tasks.new(title:@user_task.title,content:"same title")
    assert_not other_task.valid?

    other_user_same_title_task = @other_user.tasks.new(title:@user_task.title,content:"other user but same title")
    assert other_user_same_title_task.valid?
  end

  test "title should be length more than 30" do
    @user_task.save
    @user_task.title = "a" * 31
    assert_not @user_task.valid?
  end
end
