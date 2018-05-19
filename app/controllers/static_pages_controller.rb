class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      # 検索拡張機能として.search(params[:search])を追加 
      @feed_items = current_user.feed.paginate(page: params[:page]).search(params[:search])
    end
  end

  def help
  end
  
  def about
  end  
  
  def contact
  end  
  
end
