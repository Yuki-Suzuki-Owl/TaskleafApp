# require "test_helper"
#
# class UsersEditTest < ActionDispatch::IntegrationTest
#   # test "the truth" do
#   #   assert true
#   # end
#   def setup
#     # @user = User.new(name:"user",email:"user@email.com",password:"password",password_confirmation:"password")
#     # @user.save
#     @admin_user = users(:sampleuser)
#     @other_user = users(:otheruser)
#     log_in @other_user
#   end
#
#   test "unsuccessfull edit wrong user" do
#     # assert_raise(ActiveRecord::RecordNotFound,NoMethodError) do
#     #   get edit_admin_user_path(@other_user)
#     # end
#     # assert_template admin_user_path(@user)
#     get edit_admin_user_path(@admin_user)
#     follow_redirect!
#     assert_template "tasks/index"
#
#     name = "false name"
#     patch admin_user_path(@admin_user),params:{user:{name:name,email:""}}
#     assert_not_equal name,@admin_user.reload.name
#   end
#
#   test "unsucessfull edit" do
#     get edit_admin_user_path(@other_user)
#     assert_template "admin/users/edit"
#     patch admin_user_path(@other_user),params:{user:{name:"",email:""}}
#     assert_template "admin/users/edit"
#     assert_equal @other_user.name,@other_user.reload.name
#   end
#
#   test "successfull edit" do
#     5.times do |i|
#       task = @other_user.tasks.create!(title:"user task#{i}")
#       @other_user.group.tasks << task
#     end
#     assert_equal @other_user.group.tasks.count,5
#     get edit_admin_user_path(@other_user)
#     assert_template "admin/users/edit"
#     email = "changed@email.com"
#     group = groups(:second_group)
#     before_group = @other_user.group
#     patch admin_user_path(@other_user),params:{user:{name:@other_user.name,email:email,group_id:group.id}}
#     follow_redirect!
#     assert_not flash.empty?
#     assert_template "admin/users/show"
#     @other_user.reload
#     assert_equal email,@other_user.email
#     assert_equal group.name,@other_user.group.name
#
#     # before_group.tasks.each do |task|
#     #   assert_not @other_user.tasks.include?(task)
#     # end
#     @other_user.tasks.each do |task|
#       assert_not before_group.tasks.include?(task)
#     end
#     assert_equal before_group.tasks.count,0
#   end
#
#   test "unsuccessful destroy" do
#     assert_no_difference "User.count" do
#       delete admin_user_path(@other_user)
#     end
#     follow_redirect!
#     assert_template "tasks/index"
#
#     log_out
#     log_in @admin_user
#     assert_no_difference "User.count" do
#       delete admin_user_path(@admin_user)
#     end
#     assert_template "admin/users/index"
#   end
#
#   test "successfull destroy" do
#     log_out
#     log_in @admin_user
#     assert_difference "User.count",-1 do
#       delete admin_user_path(@other_user)
#     end
#     follow_redirect!
#     assert_template "admin/users/index"
#   end
# end
