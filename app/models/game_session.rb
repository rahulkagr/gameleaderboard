class GameSession < ApplicationRecord
  belongs_to :user, dependent: :destroy
end
