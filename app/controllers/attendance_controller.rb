class AttendanceController < ApplicationController
  
  # 出勤・退社ボタン押下　show.html.erbの出社・退社押下時反応
  def attendance_update
    # 更新する勤怠データを取得
    @attendance = Attendance.find(params[:attendance][:id])
    # 更新パラメータを文字列で取得する
    @update_type = params[:attendance][:update_type]
    
    if @update_type == 'attendance_time'
      # 出社時刻を更新 
      if !@attendance.update_column(:attendance_time, Time.current)
        flash[:error] = "出社時間の入力に失敗しました"
      else
        flash[:success] = "出社時間を入力しました"
      end
    elsif @update_type == 'leaving_time'
      # 退社時刻を更新 
      if !@attendance.update_column(:leaving_time, Time.current)
        flash[:error] = "退社時間の入力に失敗しました"
      else
        flash[:success] = "退社時間を入力しました"
      end
       
    end  
    #出社・退社押下した日付及び現在のuser idを@userに返す
    @user = User.find(params[:attendance][:user_id])
    redirect_to @user
  end
   
  def attendance_edit
    if current_user
    @user = User.find(params[:id])
    end
    
    #上長ユーザを全取得し、上長のみを取得
    @superior_users = User.where.not(id: @user.id, superior: false)
    
    # 曜日表示用に使用する
    @youbi = %w[日 月 火 水 木 金 土]
    
    # 上長ユーザを全取得し、上長のみを取得
    #申請が承諾されたidを取得
    #@example = User.where.not(id: @user.id, superior: false).each {|s| ids.push(s.id) if s.id != @user.applied_user_id }
    @superior_users = User.where.not(id: @user.id, superior: false)

     # 既に表示月があれば、表示月を取得する
    if !params[:first_day].nil?
      @first_day = Date.parse(params[:first_day])
    else
      # 表示月が無ければ、今月分を表示
      @first_day = Date.new(Date.today.year, Date.today.month, 1)
    end
    #最終日を取得する
    @last_day = @first_day.end_of_month

    # 今月の初日から最終日の期間分を取得
    (@first_day..@last_day).each do |date|
      # 該当日付のデータがないなら作成する
      #(例)user1に対して、今月の初日から最終日の値を取得する
      if !@user.attendances.any? {|attendance| attendance.day == date }
        linked_attendance = Attendance.create(user_id: @user.id, day: date)
        linked_attendance.save
      end
    end
    #development.sqlite3を参照
    # 表示期間のデータを日付順にソートして取得
    @attendances = @user.attendances.where('day >= ? and day <= ?', @first_day, @last_day).order("day ASC")
  end
  
  def update_all
   @user = User.find(params[:id])  
   #当月の各日付ごとに出社時間及び退社時間をチェックする
   params[:attendance].each do |id, item|
   attendance = Attendance.find(id)

    # 翌日チェックONなら基本時間から終了予定時間を＋1日する
    if !item["check"].blank?
      attendance.update_column(:expected_end_time, attendance.expected_end_time+1.day)
    end
    
    if !item["remarks"].blank?
      attendance.update_attributes(item.permit(:remarks))
    end  



    
    # 出勤・退社時間が表記されていれば、出勤・退社時刻を入力する  
    if !params[:check].blank? && !item["authorizer_user_id"].blank?
        check = item["leaving_time(3i)"].to_i*24*60 + 24*60
      if (item["attendance_time(3i)"].to_i*24*60 + item["attendance_time(4i)"].to_i*60 + item["attendance_time(5i)"].to_i) > (check + item["leaving_time(4i)"].to_i*60 + item["leaving_time(5i)"].to_i)
          flash[:danger] = '退社時間>出社時間となるよう修正してください'
          redirect_back(fallback_location: root_path) and return
          return
      else    
        if !item["attendance_time(4i)"].blank? || !item["attendance_time(5i)"].blank?
          attendance.update_column(:attendance_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["attendance_time(4i)"].to_i, item["attendance_time(5i)"].to_i))
        end 
        if !item["leaving_time(4i)"].blank? || !item["attendance_time(5i)"].blank?
          attendance.update_column(:leaving_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["leaving_time(4i)"].to_i, item["leaving_time(5i)"].to_i))
        end
        if !item["authorizer_user_id"].blank?
          attendance.applying1!
          attendance.update_attributes(item.permit(:authorizer_user_id))
        end
      end
    elsif !item["authorizer_user_id"].blank?
      if (item["attendance_time(3i)"].to_i*24*60 + item["attendance_time(4i)"].to_i*60 + item["attendance_time(5i)"].to_i) > (item["leaving_time(3i)"].to_i*24*60 + item["leaving_time(4i)"].to_i*60 + item["leaving_time(5i)"].to_i)
          flash[:danger] = '退社時間>出社時間となるよう修正してください'
          redirect_back(fallback_location: root_path) and return
          return
      else    
        if !item["attendance_time(4i)"].blank? || !item["attendance_time(5i)"].blank?
          attendance.update_column(:attendance_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["attendance_time(4i)"].to_i, item["attendance_time(5i)"].to_i))
        end 
        if !item["leaving_time(4i)"].blank? || !item["attendance_time(5i)"].blank?
          attendance.update_column(:leaving_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["leaving_time(4i)"].to_i, item["leaving_time(5i)"].to_i))
        end
        if !item["authorizer_user_id"].blank?
          attendance.applying1!
          attendance.update_attributes(item.permit(:authorizer_user_id))
        end        
      end
    end
    
    if !params[:check].blank? && !item["authorizer_user_id"].blank?
      check = item["leaving_time_edit(3i)"].to_i*24*60 + 24*60
      # 出勤・退社時間が表記されていれば、出勤・退社時刻を入力する  
      if (item["attendance_time_edit(3i)"].to_i*24*60 + item["attendance_time_edit(4i)"].to_i*60 + item["attendance_time_edit(5i)"].to_i) > (check + item["leaving_time_edit(4i)"].to_i*60 + item["leaving_time_edit(5i)"].to_i)
          flash[:danger] = '退社時間>出社時間となるよう修正してください'
          redirect_back(fallback_location: root_path) and return
          return
      else
        if !item["attendance_time_edit(4i)"].blank? || !item["attendance_time_edit(5i)"].blank?
          attendance.update_column(:attendance_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["attendance_time_edit(4i)"].to_i, item["attendance_time_edit(5i)"].to_i))
        end 
        if !item["leaving_time_edit(4i)"].blank? || !item["attendance_time_edit(5i)"].blank?
          attendance.update_column(:leaving_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["leaving_time_edit(4i)"].to_i, item["leaving_time_edit(5i)"].to_i))
        end
        if !item["authorizer_user_id"].blank?
          attendance.applying1!
          attendance.update_attributes(item.permit(:authorizer_user_id))
        end        
      end
    elsif !item["authorizer_user_id"].blank?
      # 出勤・退社時間が表記されていれば、出勤・退社時刻を入力する  
      if (item["attendance_time_edit(3i)"].to_i*24*60 + item["attendance_time_edit(4i)"].to_i*60 + item["attendance_time_edit(5i)"].to_i) > (item["leaving_time_edit(3i)"].to_i*24*60 + item["leaving_time_edit(4i)"].to_i*60 + item["leaving_time_edit(5i)"].to_i)
          flash[:danger] = '退社時間>出社時間となるよう修正してください'
          redirect_back(fallback_location: root_path) and return
          return
      else  
        if !item["attendance_time_edit(4i)"].blank? || !item["attendance_time_edit(5i)"].blank?
          attendance.update_column(:attendance_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["attendance_time_edit(4i)"].to_i, item["attendance_time_edit(5i)"].to_i))
        end 
        if !item["leaving_time_edit(4i)"].blank? || !item["attendance_time_edit(5i)"].blank?
          attendance.update_column(:leaving_time_edit, Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, item["leaving_time_edit(4i)"].to_i, item["leaving_time_edit(5i)"].to_i))
        end
        if !item["authorizer_user_id"].blank?
          attendance.applying1!
          attendance.update_attributes(item.permit(:authorizer_user_id))
        end
      end
    end
    
  end
   #user_urlにて、当該ユーザーの今月月を表示   
   redirect_to user_url(@user, params: { id: @user.id, first_day: params[:first_day] })
  end 
  
  #【勤怠変更申請のお知らせ】の更新
  def update_applied_attendance
    # 変更チェックが1つ以上で勤怠変更情報を更新
    if !params[:check].blank?
      @attendances = Attendance.where("id in (?)", params[:over_time_edit_state])
      params[:attendance].each do |id, item|
        # 更新チェックがなければ何もしない
        if !params[:check].include?(id)
          next
        end
        
        attendance = Attendance.find(id)
        if attendance.blank?
          next
        end
        
        # 申請情報更新
        attendance.update_attributes(item.permit(:over_time_edit_state))
        
        if attendance.approval1?
          # 現在の出勤/退勤時刻を変更前として保持 @note 変更前が空（この日付では初回の変更）なら保存
          attendance.update_attributes(attendance_time_bef_edit: attendance.attendance_time) if attendance.attendance_time_bef_edit.blank?
          attendance.update_attributes(leaving_time_bef_edit: attendance.leaving_time) if attendance.leaving_time_bef_edit.blank?
          attendance.update_attributes(updated_at: Time.current)
          # 承認された場合は出勤/退勤時刻を上書きする
          attendance.update_attributes(attendance_time: attendance.attendance_time_edit, leaving_time: attendance.leaving_time_edit)
        end
      end
    end
    
    @user = User.find(params[:id])
    redirect_to user_url(@user, params: { id: @user.id, first_day: params[:first_day] })
  end
   
  def oneday_overtime #1日分の残業申請
    @user = User.find(params[:attendance][:user_id])
    
    # 終了予定時刻がNULLなら更新しない
    if params[:attendance]["expected_end_time(4i)"].blank? || params[:attendance]["expected_end_time(5i)"].blank?
      flash[:danger] = "残業申請時間を記入してください"
      redirect_to user_url(@user, params: { id: @user.id, first_day: params[:attendance][:first_day] })
      return
    end
     
    # 申請先が空なら何もしない
    if params[:attendance][:authorizer_user_id].blank?
      flash[:danger] = "残業申請の申請先が空です"
      redirect_to user_url(@user, params: { id: @user.id, first_day: params[:attendance][:first_day] })
      return
    end
    
    attendance = Attendance.find(params[:attendance][:id]) 
    # 残業申請時間が−の場合
    
    # 翌日チェックONなら終了予定時間を＋1日する
    if !params[:check].blank?
      check = params[:attendance]["expected_end_time(3i)"].to_i*24*60 + 24*60
      if (params[:attendance]["expected_end_time(3i)"].to_i*24*60  + params[:attendance][:specified_work_end_time].to_time.hour.to_i*60 + params[:attendance][:specified_work_end_time].to_time.min.to_i) > ( check + params[:attendance]["expected_end_time(4i)"].to_i*60 + params[:attendance]["expected_end_time(5i)"].to_i)
        flash[:danger] = '終了予定時刻>指定勤務終了時間となるよう修正してください'
              redirect_to user_url(@user, params: { id: @user.id, first_day: params[:attendance][:first_day] })
        return
      end
    else 
      if (params[:attendance]["expected_end_time(3i)"].to_i*24*60  + params[:attendance][:specified_work_end_time].to_time.hour.to_i*60 + params[:attendance][:specified_work_end_time].to_time.min.to_i) > ( params[:attendance]["expected_end_time(3i)"].to_i*24*60 + params[:attendance]["expected_end_time(4i)"].to_i*60 + params[:attendance]["expected_end_time(5i)"].to_i)
        flash[:danger] = '終了予定時刻>指定勤務終了時間となるよう修正してください'
              redirect_to user_url(@user, params: { id: @user.id, first_day: params[:attendance][:first_day] })
        return
      end  
    end  
   
    # 申請者が入力されていたら『申請中』に変更する
    if !params[:attendance][:authorizer_user_id].blank?
      attendance.applying!
      # 申請者の番号も保持
      @user.update_attributes(applied_user_id: params[:attendance][:authorizer_user_id])
    else
      # 空なら上書きで空とならないよう既存のものをセット
      params[:attendance][:authorizer_user_id] = attendance.authorizer_user_id
    end
    attendance.update_attributes(params.require(:attendance).permit(:business_content, :authorizer_user_id, :over_time_state))

    # 終了予定時間があれば更新
    if !params[:attendance]["expected_end_time(4i)"].blank? || !params[:attendance]["expected_end_time(5i)"].blank?
      attendance.update_column(:expected_end_time, 
      Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, 
      params[:attendance]["expected_end_time(4i)"].to_i, params[:attendance]["expected_end_time(5i)"].to_i))
    end
      # 翌日チェックONなら終了予定時間を＋1日する
        if !params[:check].blank?
          attendance.update_column(:expected_end_time, attendance.expected_end_time+1.day)
        end
    flash[:success] = "残業申請しました"
    redirect_to user_url(@user, params: { id: @user.id, first_day: params[:attendance][:first_day] })
  end
  
  def overtime_application
        @user = User.find(params[:id])
    # 変更チェックが1つ以上で各残業申請情報を更新
    if !params[:check].blank?
      params[:attendance].each do |id, item|
        # 更新チェックがなければ何もしない
        if !params[:check].include?(id)
          next
        end
        
        attendance = Attendance.find(id)
        # 申請者が入力されていたら『申請中』に変更する
        if !item[:authorizer_user_id].blank?
          attendance.applying!
         
          @user.update_attributes(applied_user_id: item[:authorizer_user_id])
        else
          # 空なら上書きで空とならないよう既存のものをセット
          item[:authorizer_user_id] = attendance.authorizer_user_id
        end
        attendance.update_attributes(item.permit(:business_content, :authorizer_user_id, :over_time_state))
        
        # 終了予定時間があれば更新
        if !item["expected_end_time(4i)"].blank? || !item["expected_end_time(5i)"].blank?
          attendance.update_column(:expected_end_time, 
          Time.zone.local(attendance.day.year, attendance.day.month, attendance.day.day, 
          params[:attendance]["expected_end_time(4i)"].to_i, params[:attendance]["expected_end_time(5i)"].to_i))
        end
      end
    end
    redirect_to user_url(@user, params: { id: @user.id, first_day: params[:first_day] })
  end
  

  # 1ヵ月分の勤怠を承認/否認等を行う
  def update_onemonth_applied_attendance
    # 変更チェックが1つ以上で勤怠変更情報を更新
    if !params[:check].blank?
      params[:application].each do |id, item|
        # 更新チェックがなければ何もしない
        if !params[:check].include?(id)
          next
        end
        attendance = OneMonthWork.find(id)
        if attendance.blank?
          next
        end
        # 申請情報更新
        attendance.update_attributes(item.permit(:application_state))
      end
    end
      
    @user = User.find(params[:id])
    redirect_to user_url(@user, params: { id: @user.id, first_day: params[:first_day] })
  end

    private
      def attendance_params
        params.require(:attendance).permit(:business_content, :over_time_state, :authorizer_user_id)
      end
end
