require 'rails_helper'

RSpec.describe User, type: :model do

  it "ファクトリが有効であること" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  let(:user) {FactoryBot.build(:user)}

  it "名前、メールアドレス、パスワード、グループがあれば有効" do
    # user = FactoryBot.build(:user)
    user.valid?
    expect(user).to be_valid
  end

  it "名前がなければ無効" do
    user.name = nil
    user.valid?
    expect(user.errors[:name]).to include "can't be blank"
  end

  it "メールアドレスが無ければ無効" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include "can't be blank"
  end

  it "メールアドレスが重複していれば無効" do
    user.save
    other_user = FactoryBot.build(:user,email:user.email)
    other_user.valid?
    expect(other_user.errors[:email]).to include "has already been taken"
  end

  it "メールアドレスが重複していなければ有効" do
    user.save
    other_user = FactoryBot.build(:user,email:"other_user@mail.com")
    other_user.valid?
    expect(other_user).to be_valid
  end

  it "パスワードがなければ無効" do
    user.password = nil
    user.valid?
    expect(user.errors[:password]).to include "can't be blank"
  end

  it "パスワードが6文字以下なら無効" do
    user.password = "a" * 5
    user.valid?
    expect(user.errors[:password]).to include "is too short (minimum is 6 characters)"
  end

  it "パスワードが6文字以上なら有効" do
    user.password = "a" * 6
    user.valid?
    expect(user).to be_valid
  end

  it "グループに所属していなければ無効" do
    user.group = nil
    user.valid?
    expect(user.errors[:group]).to include "must exist"
  end

  it "デフォルトではadminではないこと" do
    expect(user.admin).to be_falsey
  end

end
