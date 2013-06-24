class RemoveInstitutionFromGameUsers < ActiveRecord::Migration
  def up
		remove_column :game_users, :Institution
  end

  def down
		add_column :game_users, :Institution, :string
  end
end
