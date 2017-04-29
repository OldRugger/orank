require 'rails_helper'

RSpec.describe MeetsController, type: :controller do
  describe 'GET #index' do
    it 'index returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'show returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit logged in Admin' do
    it 'edit returns http success' do
      admin_login
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new logged in Admin' do
    it 'new returns http success' do
      admin_login
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit meet Admin not logged in' do
    it 'edit meet returns http unauthorized' do
      get :edit
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #new meet logged in Admin' do
    it 'new meet returns http unauthorized' do
      get :new
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'Upload extract date file' do
    context 'add meet results ' do
      before do
        post :create, meet: { name: 'test meet',
                              date: Time.now.strftime('%m/%d/%Y'),
                              input_file: fixture_file_upload('test_data/OE0014.csv') }
      end
      it 'should add add row to meet table' do
        original_filename = Meet.where(original_filename: 'OE0014.csv').first.original_filename
        expect(original_filename).to eql('OE0014.csv')
      end
      it 'should create runner records' do
        expect(Runner.count).to eql(7)
      end
      it 'should create result records' do
        expect(Result.count).to eql(7)
      end
    end
  end
end
