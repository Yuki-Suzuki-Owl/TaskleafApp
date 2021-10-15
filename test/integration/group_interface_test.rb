require "test_helper"

class GroupInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @other_user = users(:otheruser)
    @admin_user = users(:sampleuser)
    @groupA = groups(:first_group)
    @groupB = groups(:second_group)
  end

  def invalid_create_group_method
    assert_no_difference "Group.count" do
      post admin_groups_path,params:{group:{name:""}}
    end
  end

# Group Create Test
  test "login required to create a group" do
    get admin_users_path
    follow_redirect!
    assert_template "sessions/new"

    # invalid_create_group_method
    assert_no_difference "Group.count" do
      post admin_groups_path,params:{group:{name:"foobar"}}
    end
    follow_redirect!
    assert_template "sessions/new"
  end

  test "only administrators can create groups" do
    log_in @other_user
    get admin_users_path
    follow_redirect!
    assert_template "users/show"

    assert_no_difference "Group.count" do
      post admin_groups_path,params:{group:{name:"foobar"}}
    end
    follow_redirect!
    assert_template "users/show"
  end

  test "group name required" do
    log_in @admin_user
    get admin_users_path
    assert_template "users/index"

    assert_no_difference "Group.count" do
      post admin_groups_path,params:{group:{name:""}}
    end
    assert_template "users/index"
  end

  test "group name must be unique" do
    log_in @admin_user
    group_name = "sample group name"
    assert_difference "Group.count",1 do
      post admin_groups_path,params:{group:{name:group_name}}
    end
    follow_redirect!
    assert flash.any?
    assert_template "users/index"

    assert_no_difference "Group.count" do
      post admin_groups_path,params:{group:{name:group_name}}
    end
  end

# Group Update Test
  test "invalid update group" do
    log_in @admin_user
    patch admin_group_path(@groupA),params:{group:{name:""}}
    assert_equal @groupA.name,@groupA.reload.name
  end

  test "valid update group" do
    log_in @admin_user
    patch admin_group_path(@groupA),params:{group:{name:"teset"}}
    assert_not_equal @groupA.name,@groupA.reload.name
  end

# Group Destroy Test
  test "invalid destroy group" do
    log_in @other_user
    assert_no_difference "Group.count" do
      delete admin_group_path(@groupB)
    end
  end

  test "valid destroy group" do
    log_in @admin_user
    assert_difference "Group.count",-1 do
      delete admin_group_path(@groupB)
    end
  end

  test "cannot delete if there are users in the group" do
    log_in @admin_user
    assert_no_difference "Group.count" do
      delete admin_group_path(@groupA)
    end
    assert flash.any?
  end
end
