require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    # @user = User.new(name:"Test User",email:"testuser@email.com",password:"password",password_confirmation:"password")
    @user = users(:sampleuser)
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "name should be require" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be require" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "email should be unique" do
    @user.save
    other_user = @user.dup
    # other_user = User.new(name:"other user",email:"other@email.com")
    other_user.email = @user.email.upcase
    assert_not other_user.valid?
  end

  test "password should be require" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should be length more than 6" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "admin default false" do
    user = User.new(name:"name",email:"mail@email.com",password:"password",password_confirmation:"password")
    assert_not user.admin?
  end

  test "group_id should be require" do
    @user.group_id = nil
    assert_not @user.valid?
    # assert_includes Group.all,@user.group_id
  end

  test "group name should be Group instance" do
    # # @user.group_id = 999
    # assert_includes Group.all.id,@user.group_id
    # assert_not @user.valid?
  end
end
