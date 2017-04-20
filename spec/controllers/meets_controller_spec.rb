require 'rails_helper'

RSpec.describe MeetsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    it 'returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit logged in Admin' do
    it 'returns http success' do
      admin_login
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new logged in Admin' do
    it 'returns http success' do
      admin_login
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit Admin not logged in' do
    it 'returns http success' do
      request.env['HTTP_AUTHORIZATION'] = nil
      get :edit
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET #new logged in Admin' do
    it 'returns http success' do
      request.env['HTTP_AUTHORIZATION'] = nil
      get :new
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
