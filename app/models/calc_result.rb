# Calc run output - this model contains the runners calculated score.
class CalcResult < ActiveRecord::Base
  belongs_to :results
  belongs_to :meet
  belongs_to :cal_run
  belongs_to :runner
end
