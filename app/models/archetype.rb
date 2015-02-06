# Will hold the "Diablo Character Class"
# Could have been a static list,
# but for scalability purpose, I prefered to use a model

# == Schema Information
#
# Table name: archetypes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Archetype < ActiveRecord::Base
  belongs_to :toon
end
