class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create 
        begin
            @user = User.create(name: params[:name], password: params[:password])
            if @user.save
                login()
            else
                render json: {error: 'An error has occurred.'}, status: :unprocessable_entity
            end
        rescue ActiveRecord::RecordNotUnique
            render json: {error: 'The username is already taken.'}, status: :unprocessable_entity
        end

        
    end

    def user_params
        params.require(:user).permit(:name, :password)
    end

    def index
        users = User.all
        render json: users
    end

    def login
        user = User.find_by(name: params[:name])
        if user&.authenticate(params[:password])
            payload = {"id": user.id}
            token = JWT.encode(payload, Rails.application.credentials.secret_key)
            render json: {token: token, username: user.name}
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

    
end
