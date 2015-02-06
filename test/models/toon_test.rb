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

require 'test_helper'

class ToonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
