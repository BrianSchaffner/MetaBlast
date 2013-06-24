class CreateAuthTokens < ActiveRecord::Migration
  def self.up
    create_table :auth_tokens do |t|
      t.string :token
      t.datetime :deleted_at
      t.integer :game_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :auth_tokens
  end
end
