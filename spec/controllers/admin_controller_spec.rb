require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  # login admin user
  describe 'GET #index as login admin' do
    it 'returns http success' do
      admin_login
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #index as not logged in' do
    it 'returns http unauthorized' do
      request.env['HTTP_AUTHORIZATION'] = nil
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
