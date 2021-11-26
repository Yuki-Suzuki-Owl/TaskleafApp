require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  # before do
  #   driven_by(:rack_test)
  # end
  let(:group_a) {FactoryBot.create(:group,name:"GroupA")}
  let(:user) {FactoryBot.create(:user,group:group_a)}
  let(:admin_user) {FactoryBot.create(:user,group:group_a,admin:true)}
  let!(:created_task) {FactoryBot.create(:task,title:"same title",user:user)}
  let!(:other_user_task) {FactoryBot.create(:task,title:"other user task",user:admin_user)}

  describe "タスクの新規作成" do
    context "未ログイン" do
      it "ログインページに行くこと" do
        visit tasks_path
        expect(current_path).to_not eq tasks_path
        expect(current_path).to eq login_path
      end
    end
    context "ログイン済み" do
      before do
        log_in user
      end
      it "タスク一覧に行くこと" do
        visit tasks_path
        expect(current_path).to eq tasks_path
      end
      it "値が正常ならタスクを作成できること" do
        visit tasks_path
        click_link "create new your task"
        expect(current_path).to eq new_task_path
        expect{
          fill_in "Title",with:"Sample task"
          fill_in "Content",with:"something write...."
          click_button "Create Task"
        }.to change{user.tasks.count}.by(1)
        expect(page).to have_content "created!"
        expect(current_path).to eq tasks_path
        expect(page).to have_selector ".task_title",text:"Sample task"
      end
      it "値が不正ならタスクを作成できないこと" do
        visit tasks_path
        click_link "create new your task"
        expect{
          fill_in "Title",with:""
          fill_in "Content",with:""
          click_button "Create Task"
        }.to_not change{user.tasks.count}
        expect(page).to have_content "can't be blank"
      end
      it "既存のタイトルとかぶっていたら作成できないこと" do
        visit tasks_path
        click_link "create new your task"
        expect{
          fill_in "Title",with:created_task.title
          fill_in "Content",with:"This task is can't created"
          click_button "Create Task"
        }.to_not change{user.tasks.count}
        expect(page).to have_content "has already been taken"
      end
    end
  end

  describe "タスクの更新" do
    context "未ログイン" do
      it "タスク編集ページにいけないこと" do
        visit edit_task_path(created_task)
        expect(current_path).to_not eq edit_task_path(created_task)
        expect(current_path).to eq login_path
      end
    end
    context "ログイン済み" do
      before do
        log_in user
      end
      context "自分のタスクではない時" do
        it "タスク編集ページにいけないこと" do
          # visit edit_task_path(other_user_task)
          # expect(current_path).to_not eq edit_task_path(other_user_task)
          # expect(page).to raise_error
          # expect{
          #   visit edit_task_path(other_user_task)
          # }.to raise_error(ActiveRecord::RecordNotFound)
          # get edit_task_path(other_user_task)
          # expect(response).to have_http_status "404"
        end
      end
      context "自分のタスクの時" do
        before do
          visit tasks_path
          click_link created_task.title
          click_link "edit"
        end
        it "値が正常なら更新できること" do
          fill_in "Title",with:"change task title"
          fill_in "Content",with:"This is sample fooo!"
          click_button "Update"
          created_task.reload
          expect(page).to have_content "#{created_task.title} updated!"
          expect(created_task.title).to eq "change task title"
          expect(created_task.content).to eq "This is sample fooo!"
        end
        it "値が不正なら更新できないこと" do
          fill_in "Title",with:""
          fill_in "Content",with:"WRYYYYYY"
          click_button "Update"
          expect(page).to have_content "Title can't be blank"
        end
      end
    end
  end

  describe "タスクの削除" do
    context "ログイン済み" do
      before do
        log_in user
      end
      context "自分のタスクの場合" do
        it "削除できること" do
          visit tasks_path
          click_link created_task.title
          expect(current_path).to eq task_path(created_task)
          expect(page).to have_link "delete"
          expect{
            within ".task_btns" do
              page.accept_confirm do
                click_link "delete"
              end
            end
          }.to change{user.tasks.count}.by(-1)
          expect(current_path).to eq tasks_path
          expect(page).to have_content "#{created_task.title} deleted."
        end
      end

      context "自分のタスクではない場合" do

        context "privateタスクの場合" do
          it "他人のタスク一覧に行けないに事" do
            get task_path(other_user_task)
            expect(current_path).to_not eq task_path(other_user_task)
          end
        end

        context "publicタスクの場合" do
          let!(:group_task) {FactoryBot.create(:group_task,group:user.group,task:other_user_task)}
          it "ファクトリガ有効なこと" do
            group_task.valid?
            expect(group_task).to be_valid
          end
          it "削除リンクが出ていないこと" do
            visit group_tasks_path
            within ".task_btns" do
              expect(page).to_not have_link "delete"
            end
          end
        end

      end
    end
  end

  describe "タスクの公開と非公開" do
    before do
      log_in user
    end
    it "公開ボタンを押すとグループタスクが1つ増えること" do
      expect(current_path).to eq tasks_path
      click_link created_task.title
      expect(current_path).to eq task_path(created_task)
      expect{
        within ".task_btns" do
          click_button "Public"
        end
      }.to change{user.group.tasks.count}.by(1)
      expect(current_path).to eq group_tasks_path
    end

    let(:public_task) {FactoryBot.create(:group_task,group:user.group,task:created_task)}
    it "非公開のボタンを押すとグループタスクが1つ減ること" do
      public_task
      visit group_tasks_path
      expect(current_path).to eq group_tasks_path
      click_link created_task.title
      expect(current_path).to eq group_task_path(created_task)
      expect{
        within ".task_btns" do
          click_button "Unpublish"
        end
      }.to change{user.group.tasks.count}.by(-1)
      expect(current_path).to eq group_tasks_path
    end
  end
end
