require 'rails_helper'

RSpec.describe MeetsController, type: :controller do
  describe 'GET #index' do
    it 'index returns http success' do
      get :index
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

  describe 'GET #new meet logged in Admin' do
    it 'new meet returns http unauthorized' do
      get :new
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'Upload OE0014 extract data file' do
    context 'add meet results ' do
      before do
        post :create, meet: { name: 'test meet OE0014',
                              date: Time.now.strftime('%m/%d/%Y'),
                              input_file: fixture_file_upload('test_data/OE0014.csv') }
      end
      it 'should add add row to meet table' do
        original_filename = Meet.where(original_filename: 'OE0014.csv').first.original_filename
        expect(original_filename).to eql('OE0014.csv')
      end
      it 'should create runner records' do
        expect(Runner.count).to eql(14)
      end
      it 'should update runners card_id' do
        expect(Runner.where(card_id: 20262521).first.name).to eql('Anne Doe71')
      end
    end
  end
  
  describe 'Upload OR extract data file' do
    context 'add meet results ' do
      before do
        post :create, meet: { name: 'test meet OR',
                              date: Time.now.strftime('%m/%d/%Y'),
                              input_file: fixture_file_upload('test_data/OR.csv') }
      end
      it 'should add add row to meet table' do
        original_filename = Meet.where(original_filename: 'OR.csv').first.original_filename
        expect(original_filename).to eql('OR.csv')
      end
      it 'should create runner records' do
        expect(Runner.count).to eql(20)
      end
      it 'should update runners card_id' do
        expect(Runner.where(card_id: 20645041).first.name).to eql('Kevon DoeG10')
      end
    end
  end
end
