# Will hold the crucial information regarding each rift runs
# These informations will be used to build some analytics
# and help the user determine which difficulty level
# yields the best results

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
class Run < ActiveRecord::Base
  belongs_to :user
  belongs_to :toon
  has_one :difficulty
end
