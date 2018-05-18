class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate     
      log_in user
      flash[:success] = "アカウントは有効化されました！"
      redirect_to user
    else
      flash[:danger] = "アカウントは無効化です"
      redirect_to root_url
    end
  end
end