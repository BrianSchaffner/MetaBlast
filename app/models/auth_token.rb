class AuthToken < ActiveRecord::Base
  belongs_to :game_user
  
  def self.create_new_token(game_user)
    #AuthToken.expire_tokens(game_user)
    token = ActiveSupport::SecureRandom::hex(16)
    auth_token = AuthToken.create(:token => token, :game_user_id => game_user.id)
  end
  
  def self.expire_tokens(game_user)
    game_user.auth_tokens.where('deleted_at IS NULL').each do |token|
      token.expire
    end
  end
  
  def expire
    self.deleted_at = Time.now
    self.save
  end
  
  def expired?
    !self.deleted_at.nil?
  end
  
end
