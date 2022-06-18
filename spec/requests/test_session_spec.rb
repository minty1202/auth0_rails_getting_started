require 'rails_helper'

RSpec.describe "TestSessions", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/test_session/create"
      expect(response).to have_http_status(:success)
    end
  end

end
