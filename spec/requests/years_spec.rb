require 'rails_helper'

RSpec.describe 'Years API', type: :request do
  # Initialize the test data
  let!(:name) { create(:name) }
  let!(:years) { create_list(:year, 20, name_id: name.id) }

  # Test suite for GET /years
  describe 'GET /years' do
    # make HTTP get request before each example
    before { get '/years' }

    it 'returns years' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(20)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

end