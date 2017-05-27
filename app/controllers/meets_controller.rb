# Meets controller
class MeetsController < ApplicationController
  before_filter :admin_required, only: %i(edit new)
  def index
  end

  def show
    @meet = Meet.find(params[:id])
    courses = ['Red', 'Green', 'Brown', 'Orange', 'Yellow', 'Sprint']
    @results = {}
    courses.each do |c|
      @results[c] = Result.where(meet_id: @meet.id, course: c)
                    .select("id, runner_id, place, classifier, float_time")
                    .order(:classifier, :place).all
    end
  end

  def edit
  end

  def new
    @meet = Meet.new
  end

  def create
    meet = create_meet
    Result.import(meet.id, meet_params[:input_file])
    redirect_to controller: 'meets', action: 'show', id: meet.id
  end

  def create_meet
    meet = Meet.find_or_create_by(original_filename: meet_params[:input_file].original_filename)
    meet.name = meet_params[:name]
    meet.date = meet_params[:date]
    meet.save
    meet
  end

  def meet_params
    params.require(:meet).permit(:name, :date, :input_file)
  end
end
