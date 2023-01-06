class PostsController < ApplicationController
  def post_params
    params.require(:title, :user_id).permit(:body)
  end

  def index
    posts = Post.all
  
    processed_posts = posts.map do |post|
      # Replace user_id with corresponding author
      author = post.user.name
      # Append tags of post
      tags = post.tags
      post_json = post.as_json
      post_json['author'] = author
      post_json['tags'] = tags
      post_json = post_json.except(:user_id)
      post_json
    end
  
    render json: processed_posts
  end

  def create
    #First, check if a valid user_id token was supplied
    begin 
      decoded_id = JWT.decode(params[:token], Rails.application.credentials.secret_key, true)
    rescue JWT::VerificationError
      render json: {errors: "Invalid user token"}
    end
    #Create post if token was valid
    @post = Post.create(title: params[:title], body: params[:body], user_id: decoded_id[0]['id'])
      if @post.save
          #Save each tag as well
          tags = params[:tags]
          tags.each do |name|
            newTag = Tag.create(name: name, weight: 5, post_id:@post.id, user_id: decoded_id[0]['id'])
            newTag.save
          end
          render json: @post, status: :created
      else
          render json: {errors: post.errors}, status: :unprocessable_entity
      end
  end

  def count
    render json: Post.count
  end

  def get_by_id
    begin
      post = Post.find(params[:id])
    rescue
      render 'Post not found', status: 404
    else
      begin
        tags = post.tags
        #If tag was upvoted/downvoted by user, return user_id as 1. Else, return user_id as 0.
        if (params[:token])
          decoded_id = JWT.decode(params[:token], Rails.application.credentials.secret_key, true)[0]['id']
          tags.each do |tag|
            if (tag[:user_id] == decoded_id)
              tag[:user_id] = 1
            else
              tag[:user_id] = 0
            end
          end
        else
          tags.each do |tag|
            tag[:user_id] = 0
          end
        end
      rescue
        render 'Error loading post content', status: :unprocessable_entity
      else
        #Return author name instead of user_id
        author = post.user.name
        post_json = post.as_json
        post_json['author'] = author
        post_json = post_json.except(:user_id)
        render json: { :post => post_json, :tags => tags }, status: :created 
      end
    end
  end
      

  def edit
  end
end
