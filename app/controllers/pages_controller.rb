class PagesController < ApplicationController
    
    def home
       @all_new = Topic.all.to_a.keep_if{ |x| x.type == 1}
       @all_ongoing = Topic.all.to_a.keep_if{ |x| x.type == 2}
       @all_finished = Topic.all.to_a.keep_if{ |x| x.type == 3}
       @all_discussion = Topic.all.to_a.keep_if{ |x| x.type == 0}
    end
    
    def new_topic
        
    end
    
    def category
        @category = request.original_url.split('/').last
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
end
