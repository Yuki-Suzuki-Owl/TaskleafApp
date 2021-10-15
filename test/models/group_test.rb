require "test_helper"

class GroupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @group = groups(:first_group)
  end

  test "group should be valid" do
    assert @group.valid?
  end
  
  test "name should be presence" do
    @group.name = " "
    assert_not @group.valid?
  end

  test "name should be unique" do
    # other_group = @group.dup
    # assert other_group.valid?
    other_group = Group.new(name:"#{@group.name}")
    assert_not other_group.valid?
  end
end
