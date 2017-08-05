require 'rails_helper'

RSpec.describe RunnersController, type: :controller do
  before do
    meet = Meet.create(name: 'test meet OR A',
                date: Time.now.strftime('%m/%d/%Y'))
    Result.import(meet.id, fixture_file_upload('test_data/OR.csv'))
    calc_run = CalcRun.new(status: 'in-process', date: DateTime.now.to_date )
    calc_run.save
    start = Time.now
    CalculateResults.new.perform(calc_run)
    finish = Time.now
    calc_run.status = 'complete'
    calc_run.calc_time = finish - start
    calc_run.save
  end
  
  describe "GET #show" do
    let (:runner) { Runner.where(firstname: 'Chester').first }
    let (:calc_run) { CalcRun.last }
    it "returns http success" do
      get :show, id: runner.id, calc_id: calc_run.id
      expect(response).to have_http_status(:success)
    end
    
    it "returns runners results" do
      get :show, id: runner.id, calc_id: calc_run.id
      expect(assigns(:calc_results).first.course).to eql 'Red'
      expect(assigns(:rankings).first.score).to eql 104.24719588262843
    end
  end

end
