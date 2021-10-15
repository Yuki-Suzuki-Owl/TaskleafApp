class CreateGroupTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :group_tasks do |t|
      t.references :group, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
    add_index :group_tasks,[:group_id,:task_id],unique:true
  end
end
