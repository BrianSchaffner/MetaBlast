class DeviseCreateGameUsers < ActiveRecord::Migration
  def self.up
    create_table(:game_users) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :game_users, :email,                :unique => true
    add_index :game_users, :reset_password_token, :unique => true
    # add_index :game_users, :confirmation_token,   :unique => true
    # add_index :game_users, :unlock_token,         :unique => true
    # add_index :game_users, :authentication_token, :unique => true
  end

  def self.down
    drop_table :game_users
  end
end
