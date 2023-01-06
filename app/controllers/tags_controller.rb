class TagsController < ApplicationController
    def new
        name = params[:name]
        decoded_id = JWT.decode(params[:token], 
                                Rails.application.credentials.secret_key, 
                                true)[0]['id']
        post_id = params[:post_id]
        post = Post.find(post_id)
        #Determine weight of vote
        weight = (post.user_id == decoded_id) ? 5 : 1
        weight = (params[:positive]) ? weight : -weight
        current_vote = Tag.find_by(name: name, 
                                    user_id: decoded_id
                                    post_id: post_id)
        @tag = Tag.create(name: name,
                            weight: weight
                            post_id: post_id
                            user_id: decoded_id)
        if @tag.save
            #delete/overwrite the old vote, if any
            if current_vote
                current_vote.destroy
            end
            render json: @tag, status: :created
        else
            render json: {errors: tag.errors}, status: :unprocessable_entity
        end
    end

    def revoke
        name = params[:name]
        decoded_id = JWT.decode(params[:token], 
                                Rails.application.credentials.secret_key, 
                                true)[0]['id']
        post_id = params[:post_id]
        current_vote = Tag.find_by(name: name, 
            user_id: decoded_id
            post_id: post_id)

        if current_vote.destroy
            render status: 200
        else
            render json: {errors: tag.errors}, status: :unprocessable_entity
        end
    end
end
