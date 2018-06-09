require 'rails_helper'

RSpec.describe 'Names API', type: :request do
  # initialize test data
  let!(:names) { create_list(:name, 10) }
  let(:name_id) { names.first.id }

  # Test suite for GET /names
  describe 'GET /names' do
    # make HTTP get request before each example
    before { get '/names' }

    it 'returns names' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /names/:id
  describe 'GET /names/:id' do
    before { get "/names/#{name_id}" }

    context 'when the record exists' do
      it 'returns the name' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(name_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:name_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Name/)
      end
    end
  end
end