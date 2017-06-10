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
                                 'runners.firstname, runners.surname,' +
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
