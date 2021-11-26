# require "test_helper"
#
# class TasksUpdateTest < ActionDispatch::IntegrationTest
#   # test "the truth" do
#   #   assert true
#   # end
#   def setup
#     @admin_user = users(:sampleuser)
#     @other_user = users(:otheruser)
#     @my_task = tasks(:first_task)
#     @other_task = tasks(:second_task)
#   end
#
#   # test "task should be mein" do
#   #   assert_not @other_task.user == @admin_user
#   # end
#
#   test "invalid update task" do
#     get edit_task_path(@my_task)
#     follow_redirect!
#     assert_template "sessions/new"
#
#     log_in @admin_user
#     assert_raise ActiveRecord::RecordNotFound do
#       get edit_task_path(@other_task)
#     end
#
#     get edit_task_path(@my_task)
#     assert_template "tasks/edit"
#     patch task_path,params:{task:{title:"",content:"content"}}
#     assert_template "tasks/edit"
#     assert_equal @my_task,@my_task.reload
#   end
#
#   test "valid updated task and user_name should be your name" do
#     log_in @admin_user
#     get edit_task_path(@my_task)
#     assert_template "tasks/edit"
#     title = "change task title";content = "change task content";user = @other_user
#     patch task_path(@my_task),params:{task:{title:title,content:content,user:user}}
#     assert_not flash.empty?
#     follow_redirect!
#     assert_template "tasks/index"
#     @my_task.reload
#     assert_equal @my_task.title,title
#     assert_equal @my_task.content,content
#     assert_not_equal @my_task.user,user
#   end
#
#   test "invalid destroy" do
#     assert_no_difference "Task.count" do
#       delete task_path(@my_task)
#     end
#     follow_redirect!
#     assert_template "sessions/new"
#
#     log_in @other_user
#     assert_no_difference "Task.count" do
#       assert_raise ActiveRecord::RecordNotFound do
#         delete task_path(@admin_user)
#       end
#     end
#   end
#
#   test "valid destroy" do
#     log_in @admin_user
#     assert_difference "Task.count",-1 do
#       delete task_path(@my_task)
#     end
#     follow_redirect!
#     assert_template "tasks/index"
#   end
# end
