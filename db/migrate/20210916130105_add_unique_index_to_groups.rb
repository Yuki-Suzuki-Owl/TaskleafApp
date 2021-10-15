class AddUniqueIndexToGroups < ActiveRecord::Migration[6.1]
  def change
    remove_index :groups,:name
    add_index :groups,:name,unique:true
  end
end
