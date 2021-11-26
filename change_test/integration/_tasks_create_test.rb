# require "test_helper"
#
# class TasksCreateTest < ActionDispatch::IntegrationTest
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
#   test "task should be log in" do
#     get new_task_path
#     follow_redirect!
#     assert_template "sessions/new"
#
#     assert_no_difference "Task.count" do
#       post tasks_path,params:{taks:{title:"false task",content:"false task"}}
#     end
#   end
#
#   test "invalid create task" do
#     log_in @admin_user
#     get new_task_path
#     assert_template "tasks/new"
#     assert_no_difference "Task.count" do
#       post tasks_path,params:{task:{title:"",content:"false task"}}
#     end
#     assert_template "tasks/new"
#   end
#
#   test "valid create task and user_name should be your name" do
#     log_in @admin_user
#     get new_task_path
#     assert_template "tasks/new"
#     title = "test task";content = "test task content"
#     user = @other_user
#     assert_difference "Task.count",1 do
#       post tasks_path,params:{task:{title:title,content:content,user:user}}
#     end
#     assert_not flash.empty?
#     follow_redirect!
#     assert_template "tasks/index"
#
#     task = Task.find_by(title:title)
#     assert_equal task.user,@admin_user
#   end
#
#   test "task shouw should be only my task" do
#     @admin_user.tasks.each do |task|
#       assert_equal task.user,@admin_user
#     end
#   end
#
#   test "user_task_title is unique" do
#     title = "sample task"
#     content = "sample content"
#     log_in @admin_user
#     assert_difference "Task.count",1 do
#       @admin_user.tasks.create(title:title,content:content)
#     end
#     log_out
#
#     log_in @other_user
#     assert_difference "Task.count",1 do
#       @other_user.tasks.create(title:title,content:content)
#     end
#     log_out
#
#     log_in @admin_user
#     assert_no_difference "Task.count" do
#       @admin_user.tasks.create(title:title,content:content)
#     end
#     assert_difference "Task.count" ,1 do
#       @admin_user.tasks.create(title:title+"second",content:content)
#     end
#   end
# end
