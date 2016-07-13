class TopicsController < ApplicationController
  
  def create
    new_topic = Topic.new
    new_topic.user_id = current_user.id
    new_topic.title = params[:title]
    if params[:type]
      new_topic.type = 1
    else
      new_topic.type = 0
    end
    new_topic.content = params[:content]
    new_topic.save
    redirect_to root_path
  end
  
  def delete
    
  end
  
  def edit
    
  end
end
