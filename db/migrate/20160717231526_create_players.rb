class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      
      t.integer :user_id
      t.integer :topic_id
      
      t.string :role
      t.string :affiliation
      t.boolean :is_dead
      t.integer :vote_who
      t.integer :next_player_id

      t.timestamps
    end
  end
end
