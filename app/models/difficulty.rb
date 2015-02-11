# Will hold the "Diablo Difficulty levels"
# Could have been a static list,
# but for scalability purpose, I prefered to use a model

# == Schema Information
#
# Table name: difficulties
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Difficulty < ActiveRecord::Base
  validates :name, presence: true
  has_many :runs
end
