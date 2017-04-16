class RunnerGv < ActiveRecord::Base
  belongs_to :calc_run
  belongs_to :runner
end
