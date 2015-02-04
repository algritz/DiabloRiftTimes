class Toon < ActiveRecord::Base
  has_one :archetype
  belongs_to :users
  has_many :runs
end
