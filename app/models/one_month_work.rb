class OneMonthWork < ApplicationRecord
  # 所属長承認申請状態（0:無 1:申請中 2:承認 3:否認）
  enum application_state: { nothing: 0, applying: 1, approval: 2, denial:3 }
end
