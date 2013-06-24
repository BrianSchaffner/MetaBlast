class AddStateToGameUserGroups < ActiveRecord::Migration
  def self.up
    add_column :game_user_groups, :state, :string
  end

  def self.down
    remove_column :game_user_groups, :state
  end
end
