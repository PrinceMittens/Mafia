class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.integer :user_id
      
      t.string :title
      t.text :content
<<<<<<< HEAD
      t.string :category
=======
      t.type :type
>>>>>>> refs/remotes/origin/oysong

      t.timestamps
    end
  end
end
