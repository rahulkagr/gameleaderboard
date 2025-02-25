class SubmitScoreService
  def initialize(params, current_user)
    @user_id = params[:user_id]
    @score = params[:score]
    raise ArgumentError, "User ID is required" if @user_id.blank?
    raise ArgumentError, "Score is required" if @score.blank?
    raise StandardError, "Invalid score" if @score < 0
    raise StandardError, "User id and auth token does not match" if current_user.id != @user_id
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.find_by_id(@user_id)
      if(user.nil?)
        user = User.create!(id: @user_id, username: "user_#{@user_id}")
      end
      user.game_sessions.create!(score: @score, game_mode: GameSession::GAME_MODES.sample)
      { message: "Score submitted successfully", score: @score, user_id: @user_id }
    end
  end
end
