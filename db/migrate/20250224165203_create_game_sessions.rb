class CreateGameSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :game_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :score, null: false
      t.string :game_mode, null: false
      t.timestamp :timestamp, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    add_foreign_key :game_sessions, :users, on_delete: :cascade

  end
end
