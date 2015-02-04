class Run < ActiveRecord::Base
  belongs_to :user
  belongs_to :toon
  has_one :difficulty
end
