require "rails_helper"

RSpec.describe "Vendors", type: :request do
  describe "4. GET /api/v0/vendors/:id" do
    it "should a single vendor by id" do
      vendor = create(:vendor)
      get "/api/v0/vendors/#{vendor.id}"
      response_data = JSON.parse(response.body, symbolize_names: true)
      vendor_found = response_data[:data]

      expect(response).to be_successful
      expect(vendor_found).to have_key(:id)
      expect(vendor_found[:id]).to be_an(String)

      expect(vendor_found[:attributes]).to have_key(:name)
      expect(vendor_found[:attributes][:name]).to be_an(String)

      expect(vendor_found[:attributes]).to have_key(:description)
      expect(vendor_found[:attributes][:description]).to be_a(String)

      expect(vendor_found[:attributes]).to have_key(:contact_name)
      expect(vendor_found[:attributes][:contact_name]).to be_a(String)

      expect(vendor_found[:attributes]).to have_key(:contact_phone)
      expect(vendor_found[:attributes][:contact_phone]).to be_a(String)

      expect(vendor_found[:attributes]).to have_key(:credit_accepted)
      expect(vendor_found[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end
  end
end