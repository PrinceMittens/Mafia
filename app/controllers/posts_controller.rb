class PostsController < ApplicationController
  
  # game.html determines if new post should be hidden (0 for not hidden 1 for hidden)
  # If night phase and post creator is mafia, then the post is a hidden post and viewable
  # only by mod and mafia. On post rendering in game.html, post rendering checks if post should
  # be hidden && mafia post. if it's both, check user permissions before rendering
  def create
    topic_id = params[:topic_id]
    content = params[:content]
    new_post = Post.create_post(topic_id, content, current_user.id)
    if new_post.content != nil
      new_post.save
    end
    # saving new objects twice doesn't seem to cause errors
    # new_post.save
    
    redirect_to '/t/' + params[:topic_id].to_s
  end
  
  def create_in_game
    new_post = Post.new
    new_post.user_id = current_user.id
    player_id = params[:player_id]
    new_post.topic_id = params[:topic_id]
    new_post.content = params[:content]
  end
end
