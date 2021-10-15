require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    # @user = User.new(name:"test",email:"test@email.com",password:"password",password_confirmation:"password")
    # @user.save
    @user = users(:sampleuser)
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path,params:{session:{email:"",password:""}}
    assert_template "sessions/new"
    assert_not flash.empty?
    get login_path
    assert flash.empty?
  end

  test "login with valid information and logout" do
    get login_path
    assert_not logged_in? @user
    # post login_path,params:{session:{email:@user.email,password:"password"}}
    log_in @user
    follow_redirect!
    assert_template "tasks/index"
    assert logged_in? @user
    assert_not flash.empty?
    assert_select "a[href=?]",login_path,count:0
    assert_select "a[href=?]",logout_path

    delete logout_path
    assert_not logged_in? @user
    follow_redirect!
    assert_template "sessions/new"
    assert_select "a[href=?]",logout_path,count:0
  end

end
