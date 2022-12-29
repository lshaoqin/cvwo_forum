class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create 
        @user = User.create(user_params)
        if @user.save
            render json: @user, status: :created
        else
            render json: {errors: user.errors}, status: :unprocessable_entity
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
            payload = {"name": user.name}
            token = JWT.encode(payload, Rails.application.credentials.secret_key)
            render json: {token: token}
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

    
end
