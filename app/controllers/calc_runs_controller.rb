class CalcRunsController < ApplicationController
  def index
    @calc_runs = CalcRun.where(publish: true).all
    @news = News.where(publish: true).all
  end

  def show
    @calc_run = CalcRun.find(params[:id])
    @course   = params[:course]
    @filter   = params[:filter]
    @courses  = COURSES
    if @course == nil #default to Red
      @course = 'Red'
    end
    @runners = RunnerGv.joins(:runner)
                         .select('runner_gvs.id, runner_gvs.score, runner_gvs.races, ' +
                                 'runners.firstname, runners.surname, runners.id as runner_id, ' +
                                 'runners.club_description, runners.sex')
                          .where(calc_run_id: @calc_run.id, course: @course)
                          .where('races >= 2')
                            .order('runners.sex', score: :desc)
    @clubs = @runners.uniq.pluck(:club_description)
    @clubs.reject! { |c| c.to_s.empty? || c.rstrip.empty? }
    @clubs << ' '
    @clubs << 'All High Schools'
    @clubs.sort!
    if @filter && @filter.length > 0
      if @filter == 'All High Schools'
        @runners = @runners.where("runners.club_description like '% HS'")
      else
        @runners = @runners.where("runners.club_description = ?", @filter)
      end
    end
  end
  
  def show_all
    @calc_run = CalcRun.find(params[:id])
    @meet_id  = params[:meet_id]
    @calc_results = CalcResult.joins(:meet)
                      .select('meets.name, meets.date, meets.id as meet_id, count(calc_results.id) as count')
                        .where('calc_results.calc_run_id = ?', @calc_run.id)
                          .group(:name, :date)
                            .order('meets.date DESC')
                            
    @meet_id = @calc_results.first.meet_id if @meet_id == nil
    
    @calc_courses = CalcResult.joins(:meet)
                      .select('course, meets.name, meets.date, meets.id as meet_id, ' +
                              'count(calc_results.id) as count')
                        .where('calc_results.calc_run_id = ? and meets.id = ?',
                               @calc_run.id, @meet_id)
                          .group(:course)
                            .order("case course
                                      when 'Sprint' then 6
                                      when 'Yellow' then 5
                                      when 'Orange' then 4
                                      when 'Brown'  then 3
                                      when 'Green'  then 2
                                      when  'Red'   then 1
                                      else 0
                                    end ")
                                    
    @calc_details = CalcResult.joins(:meet, :runner, :result)
                      .select('calc_results.course, length, results.climb as climb, controls, course_cgv, ' +
                              'surname, firstname, runners.id as runner_id, ' +
                              'club_description, calc_results.float_time, score')
                        .where('calc_results.calc_run_id = ? and meets.id = ?',
                               @calc_run.id, @meet_id)
                          .order("case calc_results.course
                                    when 'Sprint' then 6
                                    when 'Yellow' then 5
                                    when 'Orange' then 4
                                    when 'Brown'  then 3
                                    when 'Green'  then 2
                                    when  'Red'   then 1
                                    else 0
                                  end ")

      
  end
  
  def create
    Thread.new do
      calc_run = CalcRun.new(status: 'in-process', date: DateTime.now.to_date )
      calc_run.save
      start = Time.now
      CalculateResults.new.perform(calc_run)
      finish = Time.now
      calc_run.status = 'complete'
      calc_run.calc_time = finish - start
      calc_run.save
    end
    redirect_to controller: 'admin', action: 'index'
  end
end
