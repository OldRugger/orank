class CalcRunsController < ApplicationController
  def index
    binding.pry
  end
  def create
    binding.pry
    calc_run = CalcRun.new(status: 'in-process', date: DateTime.now.to_date )
    CalculateResults.new.perform(calc_run)
    
  end
end
