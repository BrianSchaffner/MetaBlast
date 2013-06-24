class CreateGameUserGroups < ActiveRecord::Migration
  def self.up
    create_table :game_user_groups do |t|
      t.integer :game_user_id
      t.integer :group_id
      t.integer :role_id

      t.timestamps
    end
  end

  def self.down
    drop_table :game_user_groups
  end
end
