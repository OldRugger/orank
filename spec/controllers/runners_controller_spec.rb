require 'rails_helper'

RSpec.describe RunnersController, type: :controller do

  describe "GET #show" do
    xit "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
