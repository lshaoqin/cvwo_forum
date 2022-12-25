class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create 
        @user = User.create(user_params)
        if @user.save
            redirect_to new_user_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    def user_params
        params.require(:user).permit(:name, :password)
    end
end
