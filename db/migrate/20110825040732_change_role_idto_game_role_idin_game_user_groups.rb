class ChangeRoleIdtoGameRoleIdinGameUserGroups < ActiveRecord::Migration
  def self.up
    remove_column :game_user_groups, :role_id
    add_column :game_user_groups, :game_role_id, :integer
  end

  def self.down
    add_column :game_user_groups, :role_id, :integer
    remove_column :game_user_groups, :game_role_id
  end
end
