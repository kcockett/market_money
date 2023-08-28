class Vendor < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :contact_name
  validates_presence_of :contact_phone
  validates_presence_of :credit_accepted

  has_many :market_vendors
  has_many :markets, through: :market_vendors
end