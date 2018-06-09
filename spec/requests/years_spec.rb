require 'rails_helper'

RSpec.describe 'Years API', type: :request do
  # Initialize the test data
  let!(:name) { create(:name) }
  let!(:years) { create_list(:year, 20, name_id: name.id) }
  let(:name_id) { name.id }
  let(:id) { years.first.id }

  # Test suite for GET /names/:name_id/years
  describe 'GET /names/:name_id/years' do
    before { get "/names/#{name_id}/years" }

    context 'when name exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all name years' do
        expect(json.size).to eq(20)
      end
    end

    context 'when name does not exist' do
      let(:name_id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Name/)
      end
    end
  end

  # Test suite for GET /names/:name_id/years/:id
  describe 'GET /names/:name_id/years/:id' do
    before { get "/names/#{name_id}/years/#{id}" }

    context 'when name year exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the year' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when name year does not exist' do
      let(:id) { 0 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Year/)
      end
    end
  end
end