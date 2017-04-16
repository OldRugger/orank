# Result - one record for each runner, a runner can have mulitple results for a meet
class Result < ActiveRecord::Base
  belongs_to :meet
  belongs_to :runner
end
