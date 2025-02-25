class User < ApplicationRecord
  has_many :game_sessions, dependent: :destroy
  has_one :leaderboard, dependent: :destroy
end
