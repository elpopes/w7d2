class UsersController < ApplicationController
  before_action :require_logged_out, only: %i[new create]
  before_action :require_logged_in, only: %i[index show update edit]

  def index
    @users = User.self
  end

  def new
    @user = User.new
    render :new # TODO: write view for new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login(@user)
      redirect_to user_url # TODO: redirect user to bands showpage
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
