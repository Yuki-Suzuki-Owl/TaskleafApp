require 'rails_helper'

RSpec.describe "Groups", type: :system do
  # before do
  #   driven_by(:rack_test)
  # end
  let(:user) {FactoryBot.create(:user)}
  let(:admin_user) {FactoryBot.create(:user,admin:true)}

  describe "グループの新規作成" do

    context "未ログイン" do
      it "ログイン画面に行くこと" do
        visit admin_groups_path
        expect(current_path).to_not eq admin_groups_path
        expect(current_path).to eq login_path
      end
    end

    context "ログイン済み" do
      before do
        log_in login_user
      end

      context "一般ユーザーの場合" do
        let(:login_user) {user}
        it "グループページに行けないこと" do
          visit admin_groups_path
          expect(current_path).to_not eq admin_groups_path
          expect(current_path).to eq admin_user_path(user)
        end
        it "管理者ページに行けないこと" do
          visit admin_users_path
          expect(current_path).to_not eq admin_users_path
          expect(current_path).to eq admin_user_path(user)
        end
      end

      context "管理者ユーザーの場合" do
        let(:login_user) {admin_user}
        it "グループページに行けること" do
          visit admin_groups_path
          expect(current_path).to_not eq admin_user_path(admin_user)
          expect(current_path).to eq admin_groups_path
        end
        it "管理者ページに行けること" do
          visit admin_users_path
          expect(current_path).to_not eq admin_user_path(user)
          expect(current_path).to eq admin_users_path
        end

        it "値が正常ならグループが作成されること" do
          visit admin_users_path
          expect{
            within ".create_group" do
              fill_in "Group Name",with:"new group"
              click_button "Create Group"
            end
          }.to change{Group.count}.by(1)
          expect(page).to have_content "new group created"
        end

        let!(:group) {FactoryBot.create(:group,name:"first group")}
        it "値が不正ならグループが作成されないこと" do
          visit admin_users_path
          expect{
            within ".create_group" do
              fill_in "Group Name",with:group.name
              click_button "Create Group"
            end
          }.to_not change{Group.count}
          expect(page).to have_content "has already been taken"
        end
      end

    end
  end

  describe "グループの編集" do
    let!(:group) {FactoryBot.create(:group,name:"first group")}
    context "未ログイン" do
      it "ログイン画面に行くこと" do
        visit admin_group_path(group)
        expect(current_path).to_not eq admin_group_path(group)
        expect(current_path).to eq login_path
      end
    end

    context "ログイン済み" do
      before do
        log_in login_user
      end

      context "一般ユーザーの場合" do
        let(:login_user) {user}
        it "グループ詳細ページに行けないこと" do
          visit admin_group_path(group)
          expect(current_path).to_not eq admin_group_path(group)
          expect(current_path).to eq admin_user_path(user)
        end

      end
      context "管理者ユーザーの場合" do
        let(:login_user) {admin_user}
        it "グループ詳細ページに行けること" do
          visit admin_group_path(group)
          expect(current_path).to_not eq admin_user_path(admin_user)
          expect(current_path).to eq admin_group_path(group)
        end
        it "値が正常なら変更できること" do
          visit admin_group_path(group)
          expect{
            within ".update_group" do
              fill_in "Group Name",with:"change group"
              click_button "Update Group"
            end
          }.to change{group.reload.name}.from("first group").to("change group")
        end
        let!(:second_group) {FactoryBot.create(:group,name:"second group")}
        it "値が不正なら変更されないこと" do
          visit admin_group_path(group)
          expect{
            within ".update_group" do
              fill_in "Group Name",with:second_group.name
              click_button "Update Group"
            end
          }.to_not change{group.reload.name}
          expect(page).to have_content "has already been taken"
        end
      end
    end
  end

  describe "グループの削除" do
    context "未ログイン" do
      it "ログイン画面に行くこと" do
        visit admin_users_path
        expect(current_path).to_not eq admin_users_path
        expect(current_path).to eq login_path
      end
    end

    context "ログイン済み" do
      before do
        log_in login_user
      end
      context "一般ユーザーの場合" do
        let(:login_user) {user}
        it "管理者ページに行けないこと" do
          visit admin_users_path
          expect(current_path).to_not eq admin_users_path
          expect(current_path).to eq admin_user_path(user)
        end
      end
      context "管理者ユーザーの場合" do
        let(:login_user) {admin_user}
        it "管理者ページに行けること" do
          visit admin_users_path
          expect(current_path).to_not eq admin_user_path(admin_user)
          expect(current_path).to eq admin_users_path
        end
        let(:group_with_users) {FactoryBot.create(:group,:with_10_users)}
        it "グループ内にユーザーがいれば削除できないこと" do
          expect(group_with_users.users.length).to eq 10
          visit admin_users_path
          click_link group_with_users.name
          expect(current_path).to eq admin_group_path(group_with_users)
          expect{
            within ".group_link" do
              page.accept_confirm do
                click_link "delete"
              end
            end
          }.to_not change{Group.count}
          expect(page).to have_content "#{group_with_users.name} is not empty!"
        end
        let(:empty_group) {FactoryBot.create(:group)}
        it "グループ内にユーザーがいなければ削除できること" do
          expect(empty_group.users.length).to eq 0
          visit admin_users_path
          click_link empty_group.name
          expect(current_path).to eq admin_group_path(empty_group)
          expect{
            within ".group_link" do
              page.accept_confirm do
                click_link "delete"
              end
            end
          }.to change{Group.count}.by(-1)
        end
      end
    end
  end #グループの削除

end
