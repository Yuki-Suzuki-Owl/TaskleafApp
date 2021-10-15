require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin_user = users(:sampleuser)
    @other_user = users(:otheruser)
  end

# Users Create Test
  # Invalid Test
  test "must be logged in to signup" do
    get new_admin_user_path
    follow_redirect!
    assert_template "sessions/new"

    name = "sample name"; email = "sample@email.com"; password = "password"; group_id = groups(:first_group).id;
    assert_no_difference "User.count" do
      post admin_users_path,params:{user: {name:name,email:email,password:password,password_confirmation:password,group_id:group_id}}
    end
    follow_redirect!
    assert_template "sessions/new"
  end

  test "need administrator privileges to signup" do
    log_in @other_user
    get new_admin_user_path
    follow_redirect!
    assert_template "users/show"

    name = "sample name"; email = "sample@email.com"; password = "password"; group_id = groups(:first_group).id;
    assert_no_difference "User.count" do
      post admin_users_path,params:{user: {name:name,email:email,password:password,password_confirmation:password,group_id:group_id}}
    end
    follow_redirect!
    assert_template "users/show"
  end

  test "cannot sign up with an invalid value" do
    log_in @admin_user
    get new_admin_user_path
    assert_template "users/new"

    name = "sample name"; email = "sample@email.com"; password = "password"; group_id = groups(:first_group).id;
    assert_no_difference "User.count" do
      post admin_users_path,params:{user: {name:email,email:email,password:password,password_confirmation:password,group_id:""}}
    end
    assert_template "users/new"
  end

# Users Create Test
  # Valid Test
    test "valid signup test" do
      log_in @admin_user
      name = "sample name"; email = "sample@email.com"; password = "password";group_id = groups(:first_group).id
      assert_difference "User.count",1 do
        post admin_users_path,params:{user:{name:name,email:email,password:password,password_confirmation:password,group_id:group_id}}
      end
      follow_redirect!
      assert_template "admin/users/index"
      assert flash.any?
    end

# Users Update Test
  # Invalid Test
    test "login required to update" do
      string = "change"
      name = string; email = string + "@email.com"; group_id = groups(:second_group); password = "foobar"

      get edit_admin_user_path(@other_user)
      follow_redirect!
      assert_template "sessions/new"

      patch admin_user_path(@admin_user),params:{user:{name:name,email:email,group_id:group_id,password:password,password_confirmation:password}}
      @admin_user.reload
      assert_not_equal @admin_user.name,name
      assert_not_equal @admin_user.email,email
      assert_not_equal @admin_user.group_id,group_id
    end

    test "only admin or yourself can update failure pattern" do
      log_in @other_user
      get edit_admin_user_path(@admin_user)
      follow_redirect!
      assert_template "admin/users/show"
      assert_match @other_user.name,response.body

      string = "change"
      name = string; email = string + "@email.com"; group_id = groups(:second_group); password = "foobar"

      patch admin_user_path(@admin_user),params:{user:{naem:name,email:email,group_id:group_id,password:password,password_confirmation:password}}

      @admin_user.reload
      assert_not_equal name,@admin_user.name
      assert_not_equal email,@admin_user.email
      assert_not_equal group_id,@admin_user.group_id

      follow_redirect!
      assert_template "admin/users/show"
    end

    test "only the password can be changed by non-administrators" do
      log_in @other_user
      name = "change"; email = "change@email.com"; group_id = groups(:second_group).id; password = "foobar";

      patch admin_user_path(@other_user),params:{user:{name:name,email:email,group_id:group_id,password:password,password_confirmation:password}}

      @other_user.reload
      assert_not_equal name,@other_user.name
      assert_not_equal email,@other_user.email
      assert_not_equal group_id,@other_user.group.id
      assert_not @other_user.authenticate("password")
      assert @other_user.authenticate(password)

    end

# User Update Test
  # Valid Test
    test "only admin can update name,email,group_id success pattern,
    changing the group makes the public taks private" do
      name = "change";email = name + "@email.com";
      group_id = groups(:second_group).id

      # other_user_tasks = @other_user.tasks.count
      before_group       = @other_user.group
      before_group_tasks = @other_user.group.tasks.count

      @other_user.group.tasks << @other_user.tasks.take(5)

      before_group_add_tasks = before_group_tasks + 5
      assert_equal @other_user.group.tasks.count,before_group_add_tasks

      log_in @admin_user
      patch admin_user_path(@other_user),params:{user:{name:name,email:email,group_id:group_id}}

      @other_user.reload
      assert_equal name,@other_user.name
      assert_equal email,@other_user.email
      assert_equal group_id,@other_user.group.id

      assert_equal before_group.name,groups(:first_group).name
      assert_equal before_group_add_tasks - 5,before_group_tasks
    end

# User Destroy Test
  # Invalid Test
  test "only admin can delete users failure pattern" do
    log_in @other_user

    assert_no_difference "User.count" do
      delete admin_user_path(@other_user)
    end
    follow_redirect!
    assert_template "users/show"
  end
# User Destroy Test
  # Valid Test
  test "only admin can delete users success pattern" do
    log_in @admin_user

    before_all_tasks = Task.all.count
    other_user_tasks = @other_user.tasks.count

    assert_difference "User.count",-1 do
      delete admin_user_path(@other_user)
    end
    assert flash.any?
    follow_redirect!
    assert_template "users/index"

    assert_equal Task.all.count,(before_all_tasks - other_user_tasks)
  end
end
