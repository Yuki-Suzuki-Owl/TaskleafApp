require 'rails_helper'

RSpec.describe Group, type: :model do

  it "ファクトリが有効であること" do
    expect(FactoryBot.build(:group)).to be_valid
  end

  let(:group) {FactoryBot.build(:group,name:"development")}

  it "グループ名がなければ無効" do
    group.name = nil
    group.valid?
    expect(group.errors[:name]).to include "can't be blank"
  end

  it "グループ名が重複していれば無効" do
    group.save
    same_group_name = FactoryBot.build(:group,name:"development")
    same_group_name.valid?
    expect(same_group_name.errors[:name]).to include "has already been taken"
  end

end
