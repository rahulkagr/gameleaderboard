class GameSession < ApplicationRecord
  belongs_to :user, dependent: :destroy

  after_create :update_leaderboard

  GAME_MODES = %w[arcade classic].freeze

  private

  def update_leaderboard
    leaderboard = Leaderboard.find_by(user_id: user_id)
    if leaderboard.nil?
      leaderboard = Leaderboard.create!(user_id: user_id, total_score: 0)
    end
    leaderboard.total_score += score
    leaderboard.save!
    Leaderboard.update_ranks
  end
end
