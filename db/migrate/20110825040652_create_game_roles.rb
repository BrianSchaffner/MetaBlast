class CreateGameRoles < ActiveRecord::Migration
  def self.up
    create_table :game_roles do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :game_roles
  end
end
