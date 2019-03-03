class Attendance < ApplicationRecord
   belongs_to :user
  # 残業申請状態（0:無 1:申請中 2:承認 3:否認）
  #参考URL　https://www.sejuku.net/blog/26369#enum
  #showページ　残業申請状態
  enum over_time_state: { nothing: 0, applying: 1, approval: 2, denial:3 }
  #editページ　勤怠変更申請状態
  enum over_time_edit_state: { nothing1: 0, applying1: 1, approval1: 2, denial1:3 }
   
end
