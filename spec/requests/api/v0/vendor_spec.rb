require "rails_helper"

RSpec.describe "Vendors API", type: :request do
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
    it "SAD PATH - should return an error when searching for invalid id" do
      vendor = create(:vendor)
      get "/api/v0/vendors/9009009"
      response_data = JSON.parse(response.body, symbolize_names: true)
      vendor_found = response_data

      expect(response_data).to have_key(:errors)
      expect(response_data[:errors].first[:detail]).to eq("Could not find Vendor with 'id'=9009009")
    end
  end
  describe "5. POST /api/v0/vendors" do
    it "should create a new vendor" do
      vendor = attributes_for(:vendor)
      vendor_data = vendor.to_json
      post "/api/v0/vendors", params: vendor_data, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      new_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(response).to be_successful
      expect(new_vendor).to have_key(:id)
      expect(new_vendor[:id]).to be_a(String)

      expect(new_vendor[:attributes]).to have_key(:name)
      expect(new_vendor[:attributes][:name]).to eq("#{vendor[:name]}")

      expect(new_vendor[:attributes]).to have_key(:description)
      expect(new_vendor[:attributes][:description]).to eq("#{vendor[:description]}")

      expect(new_vendor[:attributes]).to have_key(:contact_name)
      expect(new_vendor[:attributes][:contact_name]).to eq("#{vendor[:contact_name]}")

      expect(new_vendor[:attributes]).to have_key(:contact_phone)
      expect(new_vendor[:attributes][:contact_phone]).to eq("#{vendor[:contact_phone]}")

      expect(new_vendor[:attributes]).to have_key(:credit_accepted)
      expect(new_vendor[:attributes][:credit_accepted].to_s).to eq("#{vendor[:credit_accepted]}")
    end
    it "SAD PATH: should return a 400 error if information is missing" do
      vendor = {
        "name": "Buzzy Bees",
        "description": "local honey and wax products",
        "credit_accepted": false
      }
      vendor_data = vendor.to_json
      post "/api/v0/vendors", params: vendor_data, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(result).to have_key(:errors)
      expect(result[:errors].first[:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
    end
  end
  describe "6. PATCH /api/v0/vendors/:id" do
    it "should allow updating an existing vendor" do
      vendor = create(:vendor, credit_accepted: true)
      old_name = vendor.name
      new_name = "Brunhilda's fine herbs"
      expect(Vendor.first.name).to eq(old_name)
      expect(Vendor.first.credit_accepted).to eq(true)
      
      patch "/api/v0/vendors/#{vendor.id}", params: { vendor: { name: new_name, credit_accepted: false } }.to_json, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      
      expect(response).to be_successful
      expect(Vendor.first.name).to eq(new_name)
      expect(Vendor.first.credit_accepted).to eq(false)
    end

    it "SAD PATH ex2:  Expect 404 error if given an invalid vendor id" do
      vendor = create(:vendor, credit_accepted: true)
      old_name = vendor.name
      new_name = "Brunhilda's fine herbs"
      expect(Vendor.first.name).to eq(old_name)
      expect(Vendor.first.credit_accepted).to eq(true)
      
      patch "/api/v0/vendors/123123123123", params: { vendor: { name: new_name, credit_accepted: false } }.to_json, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(result).to have_key(:errors)
      expect(result[:errors].first[:detail]).to eq("Could not find Vendor with 'id'=123123123123")
      expect(Vendor.first.name).to eq(old_name)
      expect(Vendor.first.credit_accepted).to eq(true)
    end

    it "SAD PATH ex3 Expect 400 response if passing invalid data" do
      vendor = create(:vendor, credit_accepted: true)
      old_contact_name = vendor.contact_name
      new_name = ""
      expect(Vendor.first.contact_name).to eq(old_contact_name)
      expect(Vendor.first.credit_accepted).to eq(true)
      
      patch "/api/v0/vendors/#{vendor.id}", params: { vendor: { contact_name: new_name, credit_accepted: false } }.to_json, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      result = JSON.parse(response.body, symbolize_names: true)

      expect(response).to_not be_successful
      expect(result).to have_key(:errors)
      expect(result[:errors].first[:detail]).to eq("Validation failed: Contact name can't be blank")
      expect(Vendor.first.contact_name).to eq(old_contact_name)
    end
  end
  describe "7. DELETE /api/v0/vendors/:id" do
    it "when a valid id is passed in, that vendor will be destoryed as well as any associations that the vendor had.  A status code of 204 should be sent back without any content in the body" do
      vendor = create(:vendor)
      market = create(:market)
      association = MarketVendor.create!(vendor_id: vendor.id, market_id: market.id)
      expect(Vendor.first).to eq(vendor)
      expect(Market.first).to eq(market)
      expect(MarketVendor.first).to eq(association)
      
      delete "/api/v0/vendors/#{vendor.id}"
      
      expect(response).to be_successful
      expect(Vendor.first).to eq(nil)
      expect(Market.first).to eq(market)
      expect(MarketVendor.first).to eq(nil)
    end

    it "SAD PATH If an invalid id is passed in, a 404 status code as well as a descriptive message should be sent back with the response" do
      #
    end
  end
end