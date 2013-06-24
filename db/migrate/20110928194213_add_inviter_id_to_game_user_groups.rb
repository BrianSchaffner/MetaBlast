class AddInviterIdToGameUserGroups < ActiveRecord::Migration
  def self.up
    add_column :game_user_groups, :inviter_id, :integer
  end

  def self.down
    remove_column :game_user_groups, :inviter_id
  end
end
