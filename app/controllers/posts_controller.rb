class PostsController < ApplicationController
  def post_params
    params.require(:title, :user_id).permit(:body)
  end

  def index
    posts = Post.where("created_at > ?", params[:posts_after])
    
    #Count number of votes of targetTag in post
    def count_tag(post, targetTag) 
      tags = post.tags.filter {|tag| tag.name == targetTag}
      count = 0
      tags.each do |tag|
        count += tag.weight
      end
      count
    end
      
    if (params[:filter_by_tag]) 
      targetTag = params[:filter_by_tag]
      scored_posts = posts.map do |post|
        #return pairs of [(data of post), (score of corresponding tag)]
        pair = [post, count_tag(post, targetTag)]
        pair
      end
      #Filter out posts where score of corresponding tag is less than 1
      scored_posts = scored_posts.filter {|pair| pair[1] > 0}
      if (params[:sort_by] == 'votes')
        #Negate value to sort in descending order
        scored_posts = scored_posts.sort_by {|pair| -pair[1]}
      end

      if (params[:sort_by == 'date'])
        scored_posts = scored_posts.sort_by {|pair| -(pair[0].created_at)}
      end

      scored_posts = scored_posts.map do |pair|
        # Replace user_id with corresponding author
        author = pair[0].user.name
        score = pair[1]
        post_json = pair[0].as_json
        post_json['author'] = author
        post_json['score'] = score
        post_json = post_json.except(:user_id)
        post_json
      end

      render json: scored_posts, status: 200

    else
      processed_posts = posts.map do |post|
        # Replace user_id with corresponding author
        author = post.user.name
        post_json = post.as_json
        post_json['author'] = author
        post_json = post_json.except(:user_id)
        post_json
      end
      render json: processed_posts, status: 200
    end
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
          render json: @post, status: 200
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
