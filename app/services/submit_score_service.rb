class SubmitScoreService
  def initialize(params)
    @user_id = params[:user_id].strip
    @score = params[:score]
    raise ArgumentError, "User ID is required" if @user_id.blank?
    raise ArgumentError, "Score is required" if @score.blank?
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.find_or_create_by(username: @user_id)
      user.game_sessions.create!(score: @score, game_mode: GameSession::GAME_MODES.sample)
      { message: "Score submitted successfully", score: @score, user_id: @user_id }
    end
  end
end
