class AddUsernameToGameUsers < ActiveRecord::Migration
  def self.up
    add_column :game_users, :username, :string
  end

  def self.down
    remove_column :game_users, :username
  end
end
