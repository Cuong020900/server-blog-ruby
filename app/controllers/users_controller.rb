class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    @user = User.create(user_params)
    if @user.valid?
      @token = encode_token(user_id: @user.id)
      render json: { user: @user, jwt: @token }, status: :created
    else
      render json: { error: 'Failed to create user', user: @user },
             status: :not_acceptable
    end
  end

  def user_info
    render json: { user: @user }, status: 200
  end

  private

  def user_params
    params.require(:user).permit(:username, :name, :password)
  end
end
