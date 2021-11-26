require 'rails_helper'

RSpec.describe Task, type: :model do
  it "ファクトリが有効であること" do
    expect(FactoryBot.build(:task)).to be_valid
  end

  let(:task) {FactoryBot.create(:task)}

  it "タイトルが空なら無効" do
    task.title = nil
    task.valid?
    expect(task.errors[:title]).to include "can't be blank"
  end

  it "タイトルが2文字以下なら無効" do
    task.title = "a"
    task.valid?
    expect(task.errors[:title]).to include "is too short (minimum is 2 characters)"
  end

  it "タイトルが30文字以上なら無効" do
    task.title = "a" * 31
    task.valid?
    expect(task.errors[:title]).to include "is too long (maximum is 30 characters)"
  end

  it "タイトルはユーザータスク内で一意なこと" do
    task.title = "user task"
    task.save
    same_title_task = FactoryBot.build(:task,title:"user task",user:task.user)
    same_title_task.valid?
    expect(same_title_task.errors[:title]).to include "has already been taken"
  end

  it "タイトルは別ユーザー間なら重複可能" do
    task.title = "user task"
    task.save
    other_user = FactoryBot.create(:user)
    same_title_task = FactoryBot.build(:task,title:"user task",user:other_user)
    expect(same_title_task).to be_valid
  end

  it "ユーザーと関連づいていること" do
    # p task
    task.user = nil
    # p task
    task.valid?
    expect(task.errors[:user]).to include "must exist"
  end

end
