class SplitCourseController < ApplicationController
  def index
    @split_courses = SplitCourse.all.order(:meet_id)
                            .order("case course
                                      when 'Sprint' then 7
                                      when 'White'  then 6
                                      when 'Yellow' then 5
                                      when 'Orange' then 4
                                      when 'Brown'  then 3
                                      when 'Green'  then 2
                                      when  'Red'   then 1
                                      else 0
                                    end ")
  end

  def show
    @split_course = SplitCourse.find(params[:id])
    @meet = Meet.find(@split_course.meet_id)
    @runner_splits = SplitRunner.where(split_course_id: @split_course.id)
  end
end
