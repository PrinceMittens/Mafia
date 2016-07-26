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
        @all_player = Player.all
        @all_user = User.all
        topic = Topic.find(params[:id])
        user = User.find(topic.user_id)
        @topic = topic
        @user = user
        @posts = topic.Posts
        
        @game_players = Player.where(:topic_id => topic.id, :is_dead => false)
        @mafia_players = Player.where(:topic_id => topic.id, :affiliation => 0, :is_dead => false)
        @town_players = Player.where(:topic_id => topic.id, :affiliation => 1, :is_dead => false)
        @vote_list = Array.new
        

        
        
        if topic.category == 0
            render 'pages/topic'
        elsif topic.category == 1
            render 'pages/topic'
        elsif topic.category == 2
            if topic.has_user(current_user.id)
                player = Player.where(:topic_id => topic.id, :user_id => current_user.id).first
                if topic.phase == 0
                    @vote_list = @game_players
                elsif topic.phase == 1 && player.affiliation == 0
                    @vote_list = @town_players
                end
            end
            render 'pages/game'
        end
    end
    
    def new
        @topic = Topic.new
    end    
    
    def manual
        
    end  
    
    def game
        @all_player = Player.all
        @all_user = User.all
        topic = Topic.find(params[:id])
        user = User.find(topic.user_id)
        @topic = topic
        @user = user
        @posts = topic.Posts
    end
end
