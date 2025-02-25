class RankUpdateService
  def initialize(leaderboard, user_type, old_score)
    @user_type = user_type
    @leaderboard = leaderboard
    @total_score = leaderboard.total_score
    @old_score = old_score
    @leaderboard_id = leaderboard.id
  end

  def update
    if @user_type == 'new'
      insert_and_update_rank(@total_score)
    else
      update_rank(@total_score, @old_score, @leaderboard)
    end
  end

  private

  def insert_and_update_rank(total_score)
    leaderboards = Leaderboard.where('total_score > ?', total_score).order(total_score: :asc)
    new_rank = leaderboards.first&.rank.to_i + 1 || 1

    Leaderboard.where('total_score < ?', total_score)
               .update_all("rank = rank + 1")
  end


  def update_rank(total_score, old_score, leaderboard)
    leaderboards = Leaderboard
                   .where('total_score >= ? AND total_score <= ?', old_score, total_score)
                   .order(total_score: :desc)
                   .pluck(:id, :rank, :total_score, :user_id)

    return if leaderboards.blank?
    max_rank = leaderboards.map(&:second).min
    leaderboard.update!(rank: max_rank)
    Leaderboard.where(id: leaderboards.map(&:first) - [leaderboard.id])
              .update_all("rank = rank + 1")
    RedisHelper.flush_cache(prepare_cache_keys(leaderboards))
  end

  def prepare_cache_keys(leaderboards)
    leaderboards.map{|a| "player_rank_#{a[3]}"}
  end
end
