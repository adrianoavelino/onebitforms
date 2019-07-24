require 'rails_helper'

RSpec.describe "Ap1::V1::Questions", type: :request do
  describe "GET /ap1/v1/questions" do
    it "works! (now write some real specs)" do
      get ap1_v1_questions_index_path
      expect(response).to have_http_status(200)
    end
  end
end
