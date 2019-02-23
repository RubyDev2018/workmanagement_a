class BasePoint < ApplicationRecord
  # 残業申請状態（0:無 1:出勤 2:退勤）
  enum attendance_state: { nothing: 0, work_start: 1, work_end: 2 }
  
end
