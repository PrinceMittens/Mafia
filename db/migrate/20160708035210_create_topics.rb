class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.integer :user_id
      
      t.string :title
      t.text :content
      
      # 0: Regular Thread
      # 1: Sign-up Thread
      # 2: Game Thread
      # 3: Endgame Thread
      t.integer :type

      t.timestamps
    end
  end
end
