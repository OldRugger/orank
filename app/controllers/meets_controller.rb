# Meets controller
class MeetsController < ApplicationController
  before_filter :admin_required, only: [:edit, :new]
  def index
  end

  def show
  end

  def edit
  end

  def new
    @meet = Meet.new
  end

  def create
    @meet = Meet.find_or_create_by(input_file: meet_params[:input_file].original_filename)
    @meet.name = meet_params[:name]
    @meet.date = meet_params[:date]
    @meet.save
    redirect_to controller: 'meets', action: 'show', id: @meet.id
  end

  def meet_params
    params.require(:meet).permit(:name, :date, :input_file)
  end
end
