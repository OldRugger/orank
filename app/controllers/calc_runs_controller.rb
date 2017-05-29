class CalcRunsController < ApplicationController
  def index
    @calc_runs = CalcRun.where(publish: true).all
    @news = News.where(publish: true).all
  end

  def show
    @calc_run = CalcRun.find(params[:id])
    @course   = params[:course]
    if @course == nil #default to Red
      @course = 'Red'
    end
    @runners = RunnerGv.joins(:runner)
                         .select('runner_gvs.id, runner_gvs.score, ' +
                                 'runners.firstname, runners.surname, runners.club_description')
                           .where(calc_run_id: @calc_run.id, course: @course).order(:score)
    binding.pry
  end
  
  def create
    calc_run = CalcRun.new(status: 'in-process', date: DateTime.now.to_date )
    calc_run.save
    start = Time.now
    CalculateResults.new.perform(calc_run)
    finish = Time.now
    calc_run.status = 'complete'
    calc_run.calc_time = finish - start
    calc_run.save
    redirect_to controller: 'admin', action: 'index'
  end
end
