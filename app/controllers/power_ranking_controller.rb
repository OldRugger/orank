class PowerRankingController < ApplicationController
  def show
    @calc_run_id = params[:id]
    @ranking_classes = ['Varsity', 'Junior Varsity', 'Intermediate']
    @rankings_hash = Hash.new
    @runners_hash = Hash.new
    @ranking_classes.each do |ranking_class|
      rankings = PowerRanking.where(calc_run_id: @calc_run_id, ranking_class: ranking_class)
                                .order(total_score: :desc)
      @rankings_hash[ranking_class] = rankings
      rankings.each do |ranking|
        runners = RankingAssignment.joins(:runner, :runner_gv)
                    .select('runners.id, runners.firstname, runners.surname, normalized_score')
                      .where(power_ranking_id: ranking.id)
        @runners_hash["#{ranking.school}:#{ranking_class}"] = runners
        
      end
    end
  end
end
