class RankingAssignment < ActiveRecord::Base
  belongs_to :power_ranking
  belongs_to :runner
  belongs_to :runner_gv
end
