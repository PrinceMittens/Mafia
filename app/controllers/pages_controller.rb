class PagesController < ApplicationController
    
    def home
       @all_new = Topic.all.to_a.keep_if{ |x| x.category == 'newgame'}
       @all_ongoing = Topic.all.to_a.keep_if{ |x| x.category == 'ongoing'}
       @all_finished = Topic.all.to_a.keep_if{ |x| x.category == 'finished'}
       @all_discussion = Topic.all.to_a.keep_if{ |x| x.category == 'discussion'}
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
    
    def manual
        
    end    
end
