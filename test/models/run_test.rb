# == Schema Information
#
# Table name: runs
#
#  id                           :integer          not null, primary key
#  duration                     :integer          not null
#  legendary_count              :integer
#  blood_shard_count            :integer
#  duration_full_clear          :integer
#  legendary_count_full_clear   :integer
#  blood_shard_count_full_clear :integer
#  user_id                      :integer          not null
#  toon_id                      :integer          not null
#  difficulty_id                :integer          not null
#  player_count                 :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

require 'test_helper'

class RunTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
