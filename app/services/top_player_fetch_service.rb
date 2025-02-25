class TopPlayerFetchService

  TOP = 10.freeze

  def call
    leaderboard = Leaderboard.order(total_score: :desc).limit(TOP)
    leaderboard.map { |l| { user_id: l.user_id, rank: l.rank, total_score: l.total_score } }
  end
end
