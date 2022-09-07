# frozen_string_literal: true

describe Api::V1::ListingsController, type: :request do
  let!(:listing) { create(:listing) }

  describe '#index' do
    let(:query) { get '/api/v1/listings' }

    it 'returns status code 200' do
      query
      expect(response).to have_http_status(:ok)
    end

    it 'returns the serialized listings' do
      query
      expect(rendered_json['data'][0]['type']).to eq('listing')
    end

    it 'returns the serialized collection' do
      query
      expect(rendered_json['data'].length).to eq(1)
    end
  end

  describe '#show' do
    let(:listing) { create(:listing, num_rooms: 2) }
    let(:query) { get "/api/v1/listings/#{listing.id}" }

    it 'returns status code 200' do
      query
      expect(response).to have_http_status(:ok)
    end

    it 'returns the serialized listing' do
      query
      expect(rendered_json['data']['type']).to eq('listing')
    end

    it 'returns the serialized object' do
      query
      expect(rendered_json['data']['id']).to eq(listing.id.to_s)
    end
  end

  describe '#create' do
    let(:query) { post '/api/v1/listings', params: { listing: { num_rooms: 3 } } }

    it 'returns status code 200' do
      query

      expect(response).to have_http_status(:ok)
    end

    it 'returns the serialized listing' do
      query

      expect(rendered_json['data']['type']).to eq('listing')
    end

    it 'creates the listing' do
      expect { query }.to change(Listing.where(num_rooms: 3), :count).by(1)
    end
  end

  describe '#update' do
    let(:query) { put "/api/v1/listings/#{listing.id}", params: { listing: { num_rooms: 4 } } }

    it 'returns status code 200' do
      query
      expect(response).to have_http_status(:ok)
    end

    it 'updates the attributes on listing' do
      query
      expect(Listing.where(num_rooms: 4).count).to eq(1)
    end

    it 'returns the serialized listing' do
      query
      expect(rendered_json['data']['type']).to eq('listing')
    end
  end

  describe '#destroy' do
    let(:query) { delete "/api/v1/listings/#{listing.id}" }

    it 'returns status code 200' do
      query
      expect(response).to have_http_status(:ok)
    end

    it 'destroy the attributes on listing' do
      query
      expect(Listing.count).to eq(0)
    end

    it 'returns the serialized listing' do
      query
      expect(rendered_json['data']['type']).to eq('listing')
    end
  end
end
