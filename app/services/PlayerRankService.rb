class PlayerRankService
  def initialize(params)
    @user_id = params[:user_id]
    raise ArgumentError, "User ID is required" if @user_id.strip.blank?
    @player = User.find_by(username: @user_id)
    raise ArgumentError, "User not found" if @player.blank?
  end

  def call
    rank = @player.try(:leaderboard).try(:rank)
    { user_id: @user_id, rank: (rank.blank? ? "Rank does not exist" : rank) }
  end
end
