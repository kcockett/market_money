class Market < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :street
  validates_presence_of :city
  validates_presence_of :county
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :lat
  validates_presence_of :lon

  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  scope :by_state, ->(state) { where("LOWER(state) = ?", state.downcase) }
  scope :by_city, ->(city) { where("LOWER(city) = ?", city.downcase) }
  scope :by_name, ->(name) { where("LOWER(name) = ?", name.downcase) }
end