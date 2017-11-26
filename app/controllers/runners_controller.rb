class RunnersController < ApplicationController
  def show
    calc_id = params[:calc_id]
    if calc_id
      @calc_run = CalcRun.find(calc_id)
    else
      @calc_run = CalcRun.where(publish: true).order(id: :desc).first
    end
    @runner   = Runner.find(params[:id])
    @calc_results = CalcResult.joins(:meet, :result)
                      .select('meets.name as meet_name, meets.date as meet_date, ' +
                              'meets.id as meet_id, ' +
                              'results.course as course, results.length as length, ' +
                              'results.climb as climb, results.float_time as time, ' +
                              'results.classifier as cassifier, results.place as place, ' +
                              'calc_results.score as score')
                        .where(calc_run_id: @calc_run.id, runner_id: @runner.id)
                          .order('meets.date desc')
    @rankings = RunnerGv.select('course, score, races')
                  .where(calc_run_id: @calc_run.id, runner_id: @runner.id)
    @badges = Badge.where(runner_id: @runner.id).order(season: :desc).order(:sort)
    
  end
  
  def index
      if params[:q] == nil
      params[:q] = {"firstname_cont"=>"",
                    "surname_cont"=>"",
                    "club_description_cont"=>"Georgia Orienteering Club"}
    end
    @search = Runner.search(params[:q])
    page = params['page'] || 1
    calc_run_id = CalcRun.last.id
    runner_ids = RunnerGv.where(calc_run_id: calc_run_id).all.distinct(:runner_id).pluck(:runner_id)
    @runners = @search.result.select(:id, :firstname, :surname, :club_description).where(id: runner_ids).order(:surname).page(page)
    @runners_as_json = @runners.as_json
  end
 
end
