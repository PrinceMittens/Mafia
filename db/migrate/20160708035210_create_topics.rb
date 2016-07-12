class CreateTopics < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.integer :user_id
      
      t.string :title
      t.text :content
      t.type :type

      t.timestamps
    end
  end
end
