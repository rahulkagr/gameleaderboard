class PlayerRankService
  def initialize(params)
    @user_id = params[:user_id]
    raise ArgumentError, "User ID is required" if @user_id.blank?
    @player = User.find_by_id(@user_id)
    raise ArgumentError, "User not found" if @player.blank?
  end

  def call
    rank = Rails.cache.fetch("player_rank_#{@user_id}", expires_in: 1.minutes) do
      @player.try(:leaderboard).try(:rank)
    end
    { user_id: @user_id, rank: (rank.blank? ? "Rank does not exist" : rank) }
  end
end
