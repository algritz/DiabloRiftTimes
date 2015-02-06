# == Schema Information
#
# Table name: target_times
#
#  id            :integer          not null, primary key
#  target_time   :integer          not null
#  difficulty_id :integer          not null
#  player_count  :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TargetTime < ActiveRecord::Base
end
