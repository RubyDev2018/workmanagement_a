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
  
  def attendance_display
   if logged_in?
     @user  = current_user 
   end
   #コメントアウト
    # @first_day = Time.current.beginning_of_month.to_datetime 
    # @last_day = Time.current.end_of_month.to_datetime 
   
    # 表示月があれば取得
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月がなければ今月分を表示する
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
     #今月末のデータを取得
     @last_day = @first_day.end_of_month
     
     @user.attendance_time = DateTime.now
  end
  
  def attendance_edit
    if logged_in?
     @user  = current_user 
    end
    
     # 表示月があれば取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月がなければ今月分を表示する
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
     #今月末のデータを取得
     @last_day = @first_day.end_of_month
    
  end
end      
