class PagesController < ApplicationController
    
    def home
       @all_new = Topic.all.to_a.keep_if{ |x| x.category == 1}
       @all_ongoing = Topic.all.to_a.keep_if{ |x| x.category == 2}
       @all_finished = Topic.all.to_a.keep_if{ |x| x.category == 3}
       @all_discussion = Topic.all.to_a.keep_if{ |x| x.category == 0}
    end
    
    def new_topic
        
    end
    
    def new_game
        
    end
    
    def category
        @category = request.original_url.split('/').last.to_i
        @category_real = category_real(@category)
        @all_topic = Topic.all
    end
    
    def category_real category
        if category == 1
            'New Game'
        elsif category == 0
            'Free Discussion'
        elsif category == 2
            'Ongoing Game'
        elsif category == 3
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
    
    def manual
        
    end    
end
