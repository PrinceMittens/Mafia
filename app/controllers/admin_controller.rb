class AdminController < ApplicationController
    def manage
        @all_user = User.all
        @all_topic = Topic.all
        @all_post = Post.all
        @all_player = Player.all
    end
    
    def create_user
        new_user = User.new
        new_user.name = params[:name]
        new_user.email = params[:email]
        new_user.password = params[:password]
        new_user.save
        redirect_to admin_path
        
    end
    
    def delete_user
        to_del = User.find(params[:id])
        to_del.destroy
        redirect_to admin_path
    end
    
    def create_topic
        new_topic = Topic.new
        new_topic.user_id = params[:user_id]
        new_topic.title = params[:title]
        new_topic.content = params[:content]
        if params[:category]
            new_topic.category = 1
        else
            new_topic.category = 0
        end
        new_topic.save
        redirect_to admin_path
    end
    
    def delete_topic
        to_del = Topic.find(params[:id])
        to_del.destroy
        redirect_to admin_path
    end
    
    def create_post
        new_post = Post.new
        new_post.user_id = params[:user_id]
        new_post.topic_id = params[:topic_id]
        new_post.title = params[:title]
        new_post.content = params[:content]
        new_post.save
        redirect_to admin_path
    end
    
    def delete_post
        to_del = Post.find(params[:id])
        to_del.destroy
        redirect_to admin_path
    end
    
    # game flow simulation purpose
    
    def gameflow
        
    end
    
    ## general functions for game flow
    # to update the topic entry with initial game settings
    def gamestart_general topic_id, num_mafia, num_town, day_timelimit, night_timelimit
        topic = Topic.find(topic_id)
        topic.num_mafia = num_mafia
        topic.num_town = num_town
        topic.day_timelimit = day_timelimit
        topic.night_timelimit = night_timelimit
        topic.phase = 1
        topic.num_players_alive = num_mafia + num_town
        topic.save
        
        content = "The game has started!"
        post_system_general(topic_id, content)
    end
    
    # to add a player to player table when someone joins
    def addplayer_general topic_id, user_id
        player = Player.new
        player.topic_id = topic_id
        player.user_id = user_id
        player.save
        topic = Topic.find(topic_id)
        topic.roster_count = topic.roster_count + 1
        topic.save
    end
    
    # to update player table when someone votes
    def update_vote_general player_id, topic_id, vote_who
        player_voter = Player.find(player_id)
        player_voter.vote_who = vote_who
        player_voter.save
        player_voted = Player.find(vote_who)
        player_voted.vote_count += 1
        player_voted.save
        
        topic = Topic.find(topic_id)
        phase = topic.phase
        majority = 0
        if phase == 0
            majority = topic.num_players_alive.to_i / 2 + 1
        elsif phase == 1
            majority = topic.num_mafia / 2 + 1
        end
        
        content = player_id.to_s + " has voted for " + vote_who.to_s
        post_system_general(topic_id, content)
        
        if player_voted.vote_count >= majority
            content = "Majority reached"
            post_system_general(topic_id, content)
            next_phase_general(topic_id, player_voted.id)
        end
    end
    
    # to move to the next phase
    def next_phase_general topic_id, vote_result
        game = Topic.find(topic_id)
        game.phase = (game.phase + 1) % 2       # change phase 0->1 or 1->0

        dead_player = Player.find(vote_result)
        dead_player.is_dead = true
        dead_player.save
        
        game.num_players_alive = game.num_players_alive - 1               # keep track of number of remaining players

        if dead_player.affiliation == "mafia"          # going to day phase
            game.num_mafia = game.num_mafia - 1   # one town killed
        elsif dead_player.affiliation == "town"        # going to night phase 
            game.num_town = game.num_town - 1
        end
        game.save
        
        
        content = "Player " + dead_player.id.to_s + " died. End of phase, changed to " + game.phase.to_s + ". Number of mafia: " + game.num_mafia.to_s + ". Number of town: " + game.num_town.to_s + "."
        post_system_general(topic_id, content)
        
        game_players = Player.where(:topic_id => topic_id, :is_dead => false)
        game_players.each do |player|
             player.vote_count = 0
             player.save
        end
        
        if game.num_town <= game.num_mafia
            game_end_general(topic_id, 0)
        elsif game.num_mafia == 0
            game_end_general(topic_id, 1)
        end
        
        
    end
    
    def game_end_general topic_id, who_won
        topic = Topic.find(topic_id)
        topic.who_won = who_won
        topic.save
        if who_won == 1
            content = "The game has ended! Town won"
        elsif who_won == 0
            content = "The game has ended! Mafia won"
        end
        post_system_general(topic_id, content)
        
    end
    
    def post_system_general topic_id, content
        new_post = Post.new
        new_post.user_id = Topic.find(topic_id).user_id
        new_post.topic_id = topic_id
        new_post.content = content
        new_post.save
    end
    
        
    # call from view
    def create_player
        addplayer_general(params[:topic_id], params[:user_id])
        redirect_to admin_path
    end
    
    def delete_player
        player_id = params[:id]
        player_to_del = Player.find(player_id)
        topic = Topic.find(player_to_del.topic_id)
        topic.del_player(player_to_del.id) == -1
        redirect_to admin_path
    end
    
    def simulate_game
        topic = Topic.find(params[:topic_id])
        
        gamestart_general(topic.id, 2, 6, 0, 0)
        
        while topic.who_won == -1 do
            topic = Topic.find(params[:topic_id])
            
            game_players = Player.where(:topic_id => topic.id, :is_dead => false)
            mafia_players = Player.where(:topic_id => topic.id, :affiliation => 'mafia', :is_dead => false)
            town_players = Player.where(:topic_id => topic.id, :affiliation => 'town', :is_dead => false)

            start_phase = topic.phase
            
            game_players.each do |player|
                topic = Topic.find(params[:topic_id])
                if start_phase == topic.phase and topic.who_won == -1
                    if topic.phase == 0
                        update_vote_general(player.id, topic.id, game_players[rand(game_players.count)].id)
                    elsif topic.phase == 1 and player.affiliation == 'mafia'
                        update_vote_general(player.id, topic.id, town_players[rand(town_players.count)].id)
                    end
                end
            end
            
            topic = Topic.find(params[:topic_id])
            if start_phase == topic.phase and topic.who_won == -1
                content = "Majority not reached, choosing randomly"
                post_system_general(topic.id, content)
                if topic.phase == 0
                    next_phase_general(topic.id, game_players[rand(game_players.count)].id)
                elsif topic.phase == 1
                    next_phase_general(topic.id, town_players[rand(town_players.count)].id)
                end
            end
            
        end
        redirect_to admin_path
    end
    
end