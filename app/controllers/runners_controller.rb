class RunnersController < ApplicationController
  def show
    @calc_run = CalcRun.find(params[:calc_id])
    @runner   = Runner.find(params[:id])
    @calc_results = CalcResult.joins(:meet, :result)
                      .select('meets.name as meet_name, meets.date as meet_date, ' +
                              'meets.id as meet_id, ' +
                              'results.course as course, results.length as length, ' +
                              'results.climb as climb, results.float_time as time, ' +
                              'results.classifier as cassifier, results.place as place, ' +
                              'calc_results.score as score')
                        .where(calc_run_id: @calc_run.id, runner_id: @runner.id)
                          .order('meets.date')
    @rankings = RunnerGv.select('course, score, races')
                  .where(calc_run_id: @calc_run.id, runner_id: @runner.id)
  end
end
