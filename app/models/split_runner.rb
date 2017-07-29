class SplitRunner < ActiveRecord::Base
  belongs_to :split_course
  has_many :splits, dependent: :destroy
end
