require 'rails_helper'

RSpec.describe "Users", type: :system do
  # before do
  #   driven_by(:rack_test)
  # end
  let(:user) {FactoryBot.create(:user,admin:false)}
  let(:admin_user) {FactoryBot.create(:user,admin:true)}

  describe "ユーザーの新規登録" do
    context "未ログイン" do

      it "ログインページにリダイレクトされること" do
        visit admin_users_path
        expect(current_path).to_not eq admin_users_path
        expect(current_path).to eq login_path
      end
    end

    context "ログイン済み" do
      before do
        log_in login_user
      end

      context "作成者が一般ユーザーの場合" do
        let(:login_user) {user}

        it "管理者ページが表示されないこと" do
          visit admin_users_path
          expect(current_path).to_not eq admin_users_path
          expect(current_path).to eq admin_user_path(user)
        end
        it "ユーザーが作成されないこと" do
          user_params = FactoryBot.attributes_for(:user)
          expect{
            post admin_users_path,params:{user:user_params}
          }.to_not change{User.count}
        end
      end

      context "作成者が管理者ユーザーの場合" do
        let(:login_user) {admin_user}

        it "管理者ページが表示されること" do
          visit admin_users_path
          expect(current_path).to eq admin_users_path
        end
        let!(:group) {FactoryBot.create(:group,name:"Test Group")}
        it "値が正常ならユーザーが作成されること" do
          visit admin_users_path
          expect{
            click_link "create new users"
            fill_in "Name",with:"New User"
            fill_in "Email",with:"foo@email.com"
            select group.name,from:"Group"
            fill_in "Password",with:"password"
            fill_in "Password confirmation",with:"password"
            click_button "Create"
          }.to change{User.count}.by(1)
        end

        it "値が不正ならユーザーが作成されないこと" do
          visit admin_users_path
          expect{
            click_link "create new users"
            fill_in "Name",with:""
            fill_in "Email",with:""
            select group.name,from:"Group"
            fill_in "Password",with:""
            fill_in "Password confirmation",with:""
            click_button "Create"
          }.to_not change{User.count}
        end
      end

    end
  end

  describe "ユーザーの編集" do
    context "未ログイン" do
      it "編集ページに行かないこと" do
        visit edit_admin_user_path(user)
        expect(current_path).to_not eq edit_admin_user_path(user)
        expect(current_path).to eq login_path
      end
    end

    context "ログイン済み" do
      context "一般ユーザーの場合" do
        before do
          log_in user
        end
        context "自分の編集ページではない時" do
          it "自身のuser/showに行くこと" do
            visit edit_admin_user_path(admin_user)
            expect(current_path).to_not eq edit_admin_user_path(admin_user)
            expect(current_path).to eq admin_user_path(user)
          end
        end
        context "自分の編集ページの時" do
          it "パスワード項目しか表示されていないこと" do
            visit edit_admin_user_path(user)
            expect(page.has_field?("Password")).to eq true
            expect(page.has_field?("Name")).to eq false
            expect(page.has_field?("Email")).to eq false
            expect(page.has_field?("Group")).to eq false
          end
          it "値が正常なら変更されていること" do
            expect(user.password).to eq "password"
            visit edit_admin_user_path(user)
            # テストデータのパスワードの値が変わってない？
            # expect{
            #   fill_in "Password",with:"foobar"
            #   fill_in "Password confirmation",with:"foobar"
            #   click_button "Update"
            #   expect(page).to have_content "password changed."
            #   # expect(user.password).to eq "foobar"
            # }.to change{user.reload.password}.from("password").to("foobar")
            fill_in "Password",with:"foobar"
            fill_in "Password confirmation",with:"foobar"
            click_button "Update"
            # expect(user.password).to eq "foobar"
            expect(page).to have_content "password changed."
            expect(current_path).to eq admin_user_path(user)
            # expect(user.reload.password).to eq "foobar"
            end
          it "値が不正なら変更されていないこと" do
            visit edit_admin_user_path(user)
            fill_in "Password",with:"password"
            fill_in "Password confirmation",with:"foobar"
            click_button "Update"
            expect(page).to have_content "doesn't match Password"
          end
        end
      end

      context "管理者ユーザーの場合" do
        before do
          log_in admin_user
        end
        it "名前、メールアドレス、グループ、パスワード項目の全てが表示されていること" do
          visit edit_admin_user_path(user)
          expect(page.has_field?("Name",with:user.name)).to eq true
          expect(page.has_field?("Email",with:user.email)).to eq true
          expect(page.has_field?("Group")).to eq true
          expect(page.has_field?("Password")).to eq true
          expect(page.has_field?("Password confirmation")).to eq true
        end
        it "値が正常なら変更されていること" do
          visit edit_admin_user_path(user)
          fill_in "Name",with:"change name"
          fill_in "Email",with:"change@email.com"
          select admin_user.group.name,from:"Group"
          fill_in "Password",with:""
          fill_in "Password confirmation",with:""
          click_button "Update"
          expect(user.reload.name).to eq "change name"
          expect(user.reload.email).to eq "change@email.com"
          expect(user.reload.group.name).to eq admin_user.group.name
        end
        it "値が不正なら変更されていないこと" do
          visit edit_admin_user_path(user)
          fill_in "Name",with:""
          fill_in "Email",with:""
          select admin_user.group.name,from:"Group"
          fill_in "Password",with:""
          fill_in "Password confirmation",with:""
          click_button "Update"
          expect(user.reload.name).to eq user.name
          expect(user.reload.email).to eq user.email
          expect(user.reload.group.name).to eq user.group.name
        end

        let!(:other_group) {FactoryBot.create(:group,name:"other group")}
        let!(:before_group) {FactoryBot.create(:group,name:"before group")}
        let!(:user) {FactoryBot.create(:user,:with_5_tasks_and_5_group_tasks,group:before_group)}
        it "グループが変更されたら、公開タスクが非公開になっていること" do
          expect(user.tasks.length).to eq 5
          expect(before_group.tasks.length).to eq 5
          visit edit_admin_user_path(user)
          fill_in "Name",with:user.name
          fill_in "Email",with:user.email
          select other_group.name,from:"Group"
          fill_in "Password",with:""
          fill_in "Password confirmation",with:""
          click_button "Update"
          expect(user.reload.group.name).to eq "other group"
          expect(before_group.reload.tasks.length).to_not eq 5
          expect(before_group.reload.tasks.length).to eq 0
          expect(user.reload.tasks.length).to eq 5
        end
      end
    end
  end

  describe "ユーザーの削除" do
    context "未ログイン" do
      it "ログイン画面へりダイレクトされること" do
        visit admin_users_path
        expect(current_path).to eq login_path
        expect(current_path).to_not eq admin_users_path
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
          expect(current_path).to eq admin_user_path(user)
          expect(current_path).to_not eq admin_users_path
        end
        it "user/showに削除ボタンが表示されていないこと" do
          visit admin_user_path(user)
          expect(page).to_not have_selector("a",text:"delete")
        end
      end
      context "管理者ユーザーの場合" do
        let(:login_user) {admin_user}
        let!(:delete_user) {FactoryBot.create(:user,:with_5_tasks_and_5_group_tasks)}
        it "管理者ページに行けること" do
          visit admin_users_path
          expect(current_path).to eq admin_users_path
          expect(current_path).to_not eq admin_user_path(admin_user)
        end
        it "user/indexで削除ボタンが表示されていること" do
          visit admin_users_path
          expect(page).to have_selector("a",text:"delete")
        end
        it "user/showで削除ボタンが表示されていること" do
          visit admin_user_path(user)
          expect(page).to have_selector("a",text:"delete")
        end
        it "ユーザーが1人減ること,タスクも消えていること" do
          visit admin_users_path
          expect(delete_user.tasks.length).to eq 5
          group = Group.find_by(id:delete_user.group.id)
          expect(group.tasks.length).to eq 5
          expect{
            within ".user_#{delete_user.id}" do
              page.accept_confirm do
                click_link "delete"
              end
            end
            expect(page).to have_content "#{delete_user.name} destroyed."
          }.to change{User.count}.by(-1)
          expect(group.reload.tasks.length).to eq 0
        end
        it "管理者自身は削除できないこと" do
          visit admin_users_path
          expect{
            within ".user_#{admin_user.id}" do
              page.accept_confirm do
                click_link "delete"
              end
            end
            expect(page).to have_content "cannot delete..."
          }.to_not change{User.count}
        end
      end
    end
  end

end
