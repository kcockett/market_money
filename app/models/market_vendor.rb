class MarketVendor < ApplicationRecord
  validates_presence_of :market_id
  validates_presence_of :vendor_id

  belongs_to :market
  belongs_to :vendor
end