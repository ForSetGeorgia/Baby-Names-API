require 'rails_helper'

RSpec.describe 'Names API', type: :request do
  # initialize test data
  let!(:names) { create_list(:name, 10) }
  let(:name_id) { names.first.id }

  # GET /names/search
  # - params: q, limit
  describe 'GET /names/search' do
    # valid payload
    let(:valid_attributes) { { q: 'Gio', limit: 10 } }

    context 'when the request is valid' do
      before { get '/names/search', params: valid_attributes }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request has no search' do
      before { get '/names/search', params: { limit: 10 } }

      it 'returns no matches' do
        expect(json).to be_empty
        expect(json.size).to eq(0)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

    end
  end

  # GET /names/top_by_gender
  # - params: gender, year, limit


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