require 'rails_helper'

RSpec.describe AddressGeolocationsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:address_geolocation) { create(:address_geolocation) }

    it 'returns a success response' do
      get :show, params: { id: address_geolocation.to_param }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_attributes) { attributes_for(:address_geolocation) }

      it 'creates a new AddressGeolocation' do
        allow(IpGeolocationService).to receive(:fetch_geolocation_data).and_return({ "meta": "data" })

        expect {
          post :create, params: { address_geolocation: valid_attributes }
        }.to change(AddressGeolocation, :count).by(1)
      end

      it 'renders a JSON response with the new address_geolocation' do
        allow(IpGeolocationService).to receive(:fetch_geolocation_data).and_return({ "meta": "data" })

        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
        post :create, params: { address_geolocation: valid_attributes }

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end

    context 'with invalid params' do
      let(:invalid_attributes) { { address: 'invalid_address', address_type: 'invalid_type' } }

      it 'renders a JSON response with errors' do
        request.headers['Content-Type'] = 'application/json'
        request.headers['Accept'] = 'application/json'
        post :create, params: { address_geolocation: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:address_geolocation) { create(:address_geolocation) }

    it 'destroys the requested address_geolocation' do
      expect {
        delete :destroy, params: { id: address_geolocation.to_param }
      }.to change(AddressGeolocation, :count).by(-1)
    end

    it 'renders a JSON response with a success message' do
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      delete :destroy, params: { id: address_geolocation.to_param }

      expect(response).to have_http_status(:no_content)
    end
  end
end
