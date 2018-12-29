class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(card_id: params[:session][:employee_number].downcase)
    if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        if user.admin?
          redirect_back_or users_url
        else
          redirect_back_or user
        end  
    else
      # エラーメッセージを作成する
      flash.now[:danger] = '社員番号または、パスワードが違います'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end