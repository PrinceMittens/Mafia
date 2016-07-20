class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.integer :user_id
      t.integer :player_id
      t.integer :last_registered_player_id
      
      t.string :title
      t.text :content
      
      # 0: Regular Thread
      # 1: Sign-up Thread
      # 2: Game Thread
      # 3: Endgame Thread
      t.integer :category

      t.integer :roster_count
      
      # 0: day phase
      # 1: night phase
      t.integer :phase

      t.integer :time_left
      t.boolean :gameover
      t.integer :num_players_alive
      t.integer :num_mafia
      t.integer :num_town
      
      # 1: 336 hours
      # 2: 168 hours
      # 3: 120 hours
      # 4: 72 hours
      # 5: 48 hours
      # 6: 24 hours
      # 7: 12 hours
      # 8: 6 hours
      # 9: 3 hours
      #10: 2 hours
      #11: 1 hour
      #12: 30 minutes
      #13: 15 minutes
      #14: 10 minutes
      #15: 5 minutes
      t.integer :day_timelimit
      t.integer :night_timelimit
      
      # 0: Mafia won this game
      # 1: Town won this game
      # 2: Third party won this game
      # .
      # .
      # .
      # n: Role N won this game
      t.integer :who_won
      
      t.timestamps
    end
  end
end
