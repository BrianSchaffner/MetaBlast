class AddInstitutionToGameUser < ActiveRecord::Migration
  def self.up
    add_column :game_users, :institution, :string
  end
  
  def self.down
    remove_column :game_users, :institution
  end
end
