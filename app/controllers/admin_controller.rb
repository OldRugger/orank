# Admin controller handles uploading and publishing results
class AdminController < ApplicationController
  before_action :admin_required
  def index
    @calc_runs = CalcRun.where("date > ?", Date.today - 1.year).order(id: :desc)
    @news = News.where("date > ?", Date.today - 1.year).order(id: :desc)
  end
  
end
