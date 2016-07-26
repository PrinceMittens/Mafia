class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :topic_id
      
      #0 = Mafia Post
      #1 = Town Post
      #2 = Admin Post
      #3 = TP Post
      t.integer :post_type
      t.integer :hidden
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
