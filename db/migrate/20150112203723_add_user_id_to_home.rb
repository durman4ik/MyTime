class AddUserIdToHome < ActiveRecord::Migration
  def up
    add_column :homes, :user_id, :integer
  end

  def down
    remove_column :homes, :user_id
  end
end
