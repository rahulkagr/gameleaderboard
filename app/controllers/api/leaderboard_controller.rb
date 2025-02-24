module Api
  class LeaderboardController < ApplicationController
    def submit
      render plain: "Submit Score"
    end

    def top
      render plain: "Get Leaderboard"
    end

    def rank
      render plain: "Get Player Rank"
    end
  end
end
