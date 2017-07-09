class SplitCourse < ActiveRecord::Base
  belongs_to :meet
  has_many :split_runners, dependent: :destroy
end
