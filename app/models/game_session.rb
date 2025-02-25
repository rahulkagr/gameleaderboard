class GameSession < ApplicationRecord
  belongs_to :user, dependent: :destroy

  after_create :update_leaderboard

  GAME_MODES = %w[solo team].freeze

  private

  def update_leaderboard
    user_type = 'old'
    leaderboard = Leaderboard.find_by(user_id: user_id)
    if leaderboard.nil?
      user_type = 'new'
      leaderboard = Leaderboard.create!(user_id: user_id, total_score: 0)
    end
    old_score = leaderboard.total_score
    leaderboard.total_score += score
    leaderboard.save!
    RankUpdateService.new(leaderboard, user_type, old_score).update
  end
end
