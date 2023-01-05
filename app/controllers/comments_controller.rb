class CommentsController < ApplicationController
  def fetch
    # Get the post_id from params
    post_id = params[:post_id]

    # Query the comments where the post_id matches the given post_id
    comments = Comment.where(post_id: post_id)
    processed_comments = comments.map do |comment|
      # Replace user_id with corresponding author
      author = comment.user.name
      comment_json = comment.as_json
      comment_json['author'] = author
      comment_json = comment_json.except(:user_id)
      comment_json
    end

    render json: processed_comments
  end

  def new
    #First, check if a valid user_id token was supplied
    begin 
      decoded_id = JWT.decode(params[:token], Rails.application.credentials.secret_key, true)
    rescue JWT::VerificationError
      render json: {errors: "Invalid user token"}
    end
    #Create comment if token was valid
    @comment = Comment.create(body: params[:body], post_id: params[:post_id], user_id: decoded_id[0]['id'])
    if @comment.save
        #Pass back updated list of comments to client
        fetch()
    else
        render json: {errors: comment.errors}, status: :unprocessable_entity
    end
  end

  def edit
  end

  def delete
  end
end
