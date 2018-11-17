require 'csv'

CSV.generate do |csv|
  # ユーザ情報のヘッダー
  csv_column_names = ["名前", @user.name, "所属", @user.affiliation, "社員番号", @user.card_id,
                      "出勤日数", "#{@attendance_days}日"]

  csv << csv_column_names
  
  csv << ["#{@first_day.strftime("%Y年%m月")}", "時間管理表 "]
 
  
  # 勤怠情報のヘッダー
  column_names = %w(日付 曜日 出社時間 退社時間 在社時間 備考 )
  csv << column_names
  @attendances.each do |attendance|

    # 出社時間
    !attendance.attendance_time.nil? ? attendance_time = attendance.attendance_time.strftime("%H:%M") : attendance_time = "";
    # 退社時間
    !attendance.leaving_time.nil? ? leaving_time = attendance.leaving_time.strftime("%H:%M") : leaving_time = "";
    # 在社時刻
    !attendance.attendance_time.nil? && !attendance.leaving_time.nil? ? work_sum = format("%.2f", (attendance.leaving_time - attendance.attendance_time)/3600) : work_sum = "";

    column_values = [
      attendance.day.strftime("%m/%d"),
      @youbi[attendance.day.wday],
      attendance_time,
      leaving_time,
      work_sum,
      attendance.remarks,
    ]
    csv << column_values
  end
end