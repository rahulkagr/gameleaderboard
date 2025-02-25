class Leaderboard < ApplicationRecord
  belongs_to :user, dependent: :destroy

  def self.update_ranks
    Leaderboard.order(total_score: :desc).each_with_index do |entry, index|
      entry.update(rank: index + 1)
    end
  end
end
