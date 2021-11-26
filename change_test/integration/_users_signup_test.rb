# require "test_helper"
#
# class UsersSignupTest < ActionDispatch::IntegrationTest
#   # test "the truth" do
#   #   assert true
#   # end
#   def setup
#     # name = "testuser"
#     # email = "testuser@email.com"
#     # password = "password"
#     # @user = User.new(name:name,email:email,password:password,password_confirmation:password)
#     # @user.save
#     @user = users(:sampleuser)
#     @group = groups(:first_group)
#   end
#
#   test "invalid signup information" do
#     get login_path
#     assert_template "sessions/new"
#     # post login_path,params:{session:{email:@user.email,password:"password"}}
#     # assert_redirected_to "/admin/users"
#     # follow_redirect!
#     log_in @user
#     assert logged_in? @user
#
#     get new_admin_user_path
#     assert_template "admin/users/new"
#     assert_no_difference "User.count" do
#       post admin_users_path,params:{user:{name:"",email:"",password:"",password_confirmation:""}}
#     end
#     assert_template "admin/users/new"
#   end
#
#   test "valid signup information" do
#     log_in @user
#     assert logged_in? @user
#     get new_admin_user_path
#     assert_template "admin/users/new"
#     assert_difference "User.count",1 do
#       post admin_users_path,params:{user:{name:"user",email:"user@email.com",password:"password",password_confirmation:"password",group_id:@group.id}}
#     end
#     follow_redirect!
#     assert_template "admin/users/index"
#   end
#
#   test "name should bee unique" do
#     log_in @user
#     assert_difference "User.count",1 do
#       post admin_users_path,params:{user:{name:"user",email:"user@email.com",password:"password",password_confirmation:"password",group_id:@group.id}}
#     end
#     follow_redirect!
#     assert_template "admin/users/index"
#
#     assert_no_difference "User.count" do
#       post admin_users_path,params:{user:{name:"user",email:"user@email.com",password:"password",password_confirmation:"password",group_id:@group.id}}
#     end
#     # follow_redirect!
#     # assert_template "admin/users/index"
#   end
# end
