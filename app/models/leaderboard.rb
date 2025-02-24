class Leaderboard < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
