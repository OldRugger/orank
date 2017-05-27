class CalcRunsController < ApplicationController
  def index
    binding.pry
  end
  def create
    calc_run = CalcRun.new(status: 'in-process', date: DateTime.now.to_date )
    calc_run.save
    CalculateResults.new.perform(calc_run)
    
  end
end
