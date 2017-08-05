require 'rails_helper'

RSpec.describe PowerRankingController, type: :controller do

  describe "GET #show" do
    before do
      meet = Meet.create(name: 'test meet OE0014 A',
                  date: Time.now.strftime('%m/%d/%Y'))
      Result.import(meet.id,fixture_file_upload('test_data/OE0014.csv'))
      meet = Meet.create(name: 'test meet OE0014 B',
                  date: Time.now.strftime('%m/%d/%Y'))
      Result.import(meet.id, fixture_file_upload('test_data/OE0014.csv'))
      meet = Meet.create(name: 'test meet Or A',
                  date: Time.now.strftime('%m/%d/%Y'))
      Result.import(meet.id, fixture_file_upload('test_data/OR.csv'))
      meet = Meet.create(name: 'test meet Or B',
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

    it "returns http success" do
      calc_run = CalcRun.last
      get :show, id: calc_run.id
      expect(response).to have_http_status(:success)
    end
  end

end
