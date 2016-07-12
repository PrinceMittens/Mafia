class PagesController < ApplicationController
    
    def home
        
    end
    
    def new_topic
            
    end
    
    def category
        @category = request.original_url.split('/').last
        @category_real = category_real(@category)
        @all_topic = Topic.all
    end
    
    def category_real category
        if category == 'newgame'
            'New Game'
        elsif category == 'discussion'
            'Free Discussion'
        elsif category == 'ongoing'
            'Ongoing Game'
        elsif category == 'finished'
            'Finished Game'
        end    
    end
    helper_method :category_real
    
    def topic
        @all_user = User.all
        topic = Topic.find(params[:id])
        user = User.find(topic.user_id)
        @topic = topic
        @user = user
        @posts = topic.Posts
    end
end
