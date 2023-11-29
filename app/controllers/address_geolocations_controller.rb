include AddressGeolocationsCreator

class AddressGeolocationsController < ApplicationController
  before_action :set_address_geolocation, only: %i[ show destroy ]

  # GET /address_geolocations or /address_geolocations.json
  def index
    @address_geolocations = AddressGeolocation.all

    respond_to do |format|
      format.html
      format.json { render json: JSONAPI::Serializer.serialize(@address_geolocations, is_collection: true) }
    end
  end

  # GET /address_geolocations/1 or /address_geolocations/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render json: JSONAPI::Serializer.serialize(@address_geolocation) }
    end
  end

  # GET /address_geolocations/new
  def new
    @address_geolocation = AddressGeolocation.new
  end

  # POST /address_geolocations or /address_geolocations.json
  def create
    @address_geolocation, @errors = AddressGeolocationsCreator.create_address_geolocation(address_geolocation_params)

    respond_to do |format|
      if not @address_geolocation.nil? and @errors.empty?
        format.html { redirect_to address_geolocation_url(@address_geolocation), notice: "Address Geolocation was successfully created." }
        format.json { render json: JSONAPI::Serializer.serialize(@address_geolocation), status: :created, location: @address_geolocation }
      else
        format.html { render :new, status: :unprocessable_entity }
        # We can improve the handling of errors to adhere to the JSONAPI specs
        format.json { render json: { errors: @errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /address_geolocations/1 or /address_geolocations/1.json
  def destroy
    @address_geolocation.destroy!

    respond_to do |format|
      format.html { redirect_to address_geolocations_url, notice: "Address Geolocation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_address_geolocation
    @address_geolocation = AddressGeolocation.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def address_geolocation_params
    params.require(:address_geolocation).permit(:address, :address_type)
  end
end
