module Api
  class LeaderboardController < ApplicationController
    def submit
      response = SubmitScoreService.new(params, current_user).call
      render json: { data: response }
    end

    def top
      response = TopPlayerFetchService.new().call
      render json: { data: response }
    end

    def rank
      response = PlayerRankService.new(params).call
      render json: { data: response }
    end
  end
end

# which to index rank or score -- depends on fetch top method
# if rank is cached then invalidation is difficult
# api key approach

# TODO
# 1. use caching/redis
# 3. sequene diagram
# 4. docker
# 5. use of presenter
# 6. same total score can have same rank
