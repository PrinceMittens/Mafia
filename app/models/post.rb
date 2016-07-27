class Post < ApplicationRecord
  belongs_to :User
  belongs_to :Topic
    
  def self.create_post(topic_id, content, user_id)
    new_post = Post.new
    new_post.user_id = user_id
    new_post.post_type = -1 #-1 means it's a generic non-hidden post
    new_post.topic_id = topic_id
    new_post.content = content
    new_post.hidden = 0
    topic = Topic.find(new_post.topic_id)
    player = topic.find_player_by_user(new_post.user_id)
    if player != nil
      if player.affiliation == 0
        new_post.post_type = 0
        if topic.phase == 0 
          new_post.hidden = 1
        end
      end
    end
    if new_post.content != nil
      new_post.save
    end
    return new_post
  end
  
end
