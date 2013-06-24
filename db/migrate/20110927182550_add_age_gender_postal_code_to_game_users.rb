class AddAgeGenderPostalCodeToGameUsers < ActiveRecord::Migration
  def self.up
    add_column :game_users, :age, :integer
    add_column :game_users, :postal_code, :string
    add_column :game_users, :gender, :string
  end

  def self.down
    remove_column :game_users, :gender
    remove_column :game_users, :postal_code
    remove_column :game_users, :age
  end
end
