class CommentsController < ApplicationController
  def fetch
    begin
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
    rescue
      render json: {errors: "An error occurred while fetching the comments"}, status: :unprocessable_entity
    end
  end

  def new
    #First, check if a valid user_id token was supplied
    begin 
      decoded_id = JWT.decode(params[:token], ENV['VALIDATION_KEY'], true)[0]['id']
    rescue JWT::VerificationError
      render json: {errors: "Invalid user token"}
    end
    #Create comment if token was valid
    @comment = Comment.create(body: params[:body], post_id: params[:post_id], user_id: decoded_id)
    if @comment.save
        #Pass back updated list of comments to client
        fetch()
    else
        render json: {errors: "An error may have occurred while saving your comment. Please try again!"}, status: :unprocessable_entity
    end
  end

  def edit
    #First, check if a valid user_id token was supplied
    begin 
      decoded_id = JWT.decode(params[:token], ENV['VALIDATION_KEY'], true)[0]['id']
    rescue JWT::VerificationError
      render json: {errors: "Invalid user token"}
    end

    @comment = Comment.find(params[:id])
    if @comment.user_id == decoded_id
      if @comment.update_column(:body, params[:body])
        author = @comment.user.name
        comment_json = @comment.as_json
        comment_json['author'] = author
        comment_json = comment_json.except(:user_id)
        render json: comment_json, status: 200
      else
        render json: {error: "An error occurred while updating your comment. Please try again."}, status: :unprocessable_entity
      end
    else
      render json: {error: "You may not edit a comment that does not belong to you."}, status: :unprocessable_entity
    end
  end

  def delete
    #First, check if a valid user_id token was supplied
    begin 
      decoded_id = JWT.decode(params[:token], ENV['VALIDATION_KEY'], true)[0]['id']
    rescue JWT::VerificationError
      render json: {errors: "Invalid user token"}
    end
    @comment = Comment.find(params[:comment_id])
    #Check if comment belongs to user
    if (@comment.user_id != decoded_id)
      render json: {errors: "User token mismatch - try logging out and in again"}
    else
      @comment.destroy
      render json: {}, status: 200
    end
  end
end
