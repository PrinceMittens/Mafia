class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      
      t.integer :user_id
      t.integer :topic_id
      t.string  :player_email
      t.string  :player_name
      
      t.string :role
      
      #0 = Mafia
      #1 = Town
      #2 = Admin
      #3 = TP
      t.integer :affiliation
      
      t.boolean :is_dead
      t.integer :vote_target_player_id
      t.integer :vote_count
      t.integer :next_player_id
      t.integer :prev_player_id

      t.timestamps
    end
  end
end
