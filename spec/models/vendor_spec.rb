require "rails_helper"

RSpec.describe Vendor, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
    it 'validates credit_accepted as boolean' do
      vendor = Vendor.new(:name => 'New Vendor', :description => 'test vendor', :contact_name => 'My contact', :contact_phone => '303-555-1212', :credit_accepted => 'Invalid should forced to TRUE')
      expect(vendor.credit_accepted).to eq(true)

      vendor = build(:vendor, credit_accepted: false)
      expect(vendor.credit_accepted).to eq(false)
    end
  end

  describe "relationships" do
    it {should have_many(:market_vendors) }
    it {should have_many(:markets).through(:market_vendors) }
  end
end