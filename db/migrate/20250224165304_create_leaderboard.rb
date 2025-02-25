class CreateLeaderboard < ActiveRecord::Migration[8.0]
  def change
    create_table :leaderboards do |t|
      t.references :user, null: false
      t.integer :total_score, null: false
      t.integer :rank

      t.timestamps
    end

    add_foreign_key :leaderboards, :users, on_delete: :cascade
  end
end
