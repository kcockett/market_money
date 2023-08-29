require "rails_helper"

RSpec.describe "Vendors", type: :request do
  describe "4. GET /api/v0/vendors/:id" do
    it "should a single vendor by id" do
      vendor = create(:vendor)
      get "/api/v0/vendors/#{vendor.id}"
      response_data = JSON.parse(response.body, symbolize_names: true)
      vendor_found = response_data[:data]

      expect(response).to be_successful
      expect(vendor).to have_key(:id)
      expect(vendor[:id]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to be_a(TrueClass).or be_a(FalseClass)
    end
  end
end