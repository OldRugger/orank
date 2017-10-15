require 'rails_helper'

RSpec.describe SplitCourseController, type: :controller do
  before do
    meet = Meet.create(name: 'test meet OE0014 A',
                date: Time.now.strftime('%m/%d/%Y'))
    Result.import(meet.id, fixture_file_upload('test_data/OR.csv'))
    AnalyzeSplits.new.perform(meet.id)
    meet = Meet.create(name: 'test meet Or A',
                date: Time.now.strftime('%m/%d/%Y'))
    Result.import(meet.id, fixture_file_upload('test_data/OR.csv'))
    AnalyzeSplits.new.perform(meet.id)
  end


  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
    it "should returd all courses" do
      get :index
      expect(assigns(:split_courses).count).to eql 4
    end
  end
  
  describe "Show OE0014 meet" do
    let (:meet) { Meet.where(name: 'test meet OE0014 A').first }
    let (:split_course) { SplitCourse.where(meet_id: meet.id, course: 'Red').first }
    it "should return the OE0014 'red' course runners" do
      get :show, id: split_course.id
      expect(assigns(:runner_splits).count).to eql 12
    end
  end
  
  describe "Show Or meet" do
    let (:meet) { Meet.where(name: 'test meet Or A').first }
    let (:split_course) { SplitCourse.where(meet_id: meet.id, course: 'Green').first }
    it "should return the OR 'green' course runners" do
      get :show, id: split_course.id
      expect(assigns(:runner_splits).count).to eql 12
    end
  end
  
  describe "show runners splits " do
    let (:meet) { Meet.where(name: 'test meet OE0014 A').first }
    let (:split_course) { SplitCourse.where(meet_id: meet.id, course: 'Red').first }
    let (:runner) { Runner.where(firstname: 'Chester').first }
    it "should return char data" do
      get :show_runner, runner_id: runner.id, meet_id: meet.id, id: split_course.id
      expect(assigns(:chart_data).first[:name]).to eql "Chester Doe1"
      expect(assigns(:chart_data).count).to eql 10
    end
  end
  
  describe "show all of a runners splits" do
    let (:runner) { Runner.where(firstname: 'Chester').first }
    it "should return runners splits" do
      CalcRun.new(publish: true).save
      get :show_runner_all, runner_id: runner.id
      expect(assigns(:split_courses).count).to eql 2
    end
  end

end
