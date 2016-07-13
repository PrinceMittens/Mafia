class PostsController < ApplicationController
  
  def create
    new_post = Post.new
    new_post.user_id = current_user.id
    new_post.topic_id = params[:topic_id]
    new_post.content = params[:content]
    new_post.save
    redirect_to '/t/' + params[:topic_id].to_s
  end
  
end
