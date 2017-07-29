class SplitCourseController < ApplicationController
  def index
    @split_courses = SplitCourse.where(course: COURSES).order(meet_id: :desc)
                            .order("case course
                                      when 'Sprint' then 7
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
  
  def show_runner
    @split_course = SplitCourse.find(params[:id])
    @meet = Meet.find(@split_course.meet_id)
    @split_runner = SplitRunner.where(split_course_id: @split_course.id,runner_id: params[:runner_id]).first
    @superman = Runner.where(firstname: 'Superman', surname: 'Admin').first
    @batman = Runner.where(firstname: 'Batman', surname: 'Admin').first
    fastest_splits = get_fastest_splits
    @chart_data = SplitRunner.where(split_course_id: @split_course.id).where.not(runner_id:[@superman.id, @batman.id]).map do |r|
      { name: Runner.find(r.runner_id).name, data: get_runner_split_data(r.id, fastest_splits) }
    end
  end
  
  def show_runner_all
    @runner = Runner.find(params[:runner_id])
    split_course_ids = SplitRunner.where(runner_id: @runner.id).order(split_course_id: :desc).all.pluck(:split_course_id)
    @split_courses = SplitCourse.where(id: split_course_ids).order(meet_id: :desc)
    @last_calc_id = CalcRun.where(publish: true).last.id
  end
  
  private
  
  def get_runner_split_data(split_runner_id, fastest_splits)
    runner_splits = Hash.new
    runner_splits[0] = 0
    @split_course.controls.times do |i|
      control = i+1
      split_time = Split.where(split_runner_id: split_runner_id, control: (control)).first.current_time
      runner_splits[control] = split_time -fastest_splits[control]
    end
    split_time = Split.where(split_runner_id: split_runner_id, control: (FINAL_SPLIT)).first.current_time
    runner_splits['Final'] = split_time -fastest_splits['Final']
    runner_splits
  end
  
  def get_fastest_splits
    fastest_splits = Hash.new
    runners = SplitRunner.where(split_course_id: @split_course.id).where.not(runner_id:[@superman.id, @batman.id]).pluck(:id)
    @split_course.controls.times do |i|
      control = i+1
      fastest_splits[control] = Split.where(split_runner_id: runners, control: (control)).order(:current_time).first.current_time
    end
    fastest_splits['Final'] = Split.where(split_runner_id: runners, control: (FINAL_SPLIT)).order(:current_time).first.current_time
    fastest_splits
  end
  
end
