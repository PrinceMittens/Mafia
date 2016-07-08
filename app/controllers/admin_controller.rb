class AdminController < ApplicationController
    def manage
        @all_user = User.all
        @all_topic = Topic.all
        @all_post = Post.all
    end
    
    def create_user
        new_user = User.new
        new_user.name = params[:name]
        new_user.email = params[:email]
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
end
