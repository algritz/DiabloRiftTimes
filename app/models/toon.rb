# Will hold the crucial information regarding each "Toon"
# (or character)
# Each Toon will have its own sets of statistics

# == Schema Information
#
# Table name: toons
#
#  id           :integer          not null, primary key
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  archetype_id :integer
#  user_id      :integer
#
class Toon < ActiveRecord::Base
  has_one :archetype
  belongs_to :users
  has_many :runs
  validates :name, presence: true
end
