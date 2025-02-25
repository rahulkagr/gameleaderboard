class AddIndexToLeaderboard < ActiveRecord::Migration[8.0]
  def change
    add_index :leaderboards, :total_score
  end
end
