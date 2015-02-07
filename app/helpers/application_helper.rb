# Application Helper contains helper methods that are shared
# across all views
module ApplicationHelper
  def get_archetype(num)
    Archetype.where(['id = ?', num]).first[:name]
  end

  def get_toon_name(num)
    Toon.where(['id = ?', num]).first[:name]
  end

  def get_difficulty_name(num)
    Difficulty.where(['id =?', num]).first[:name]
  end

  def get_player_count(num)
    if num == 1
      'Solo'
    else
      num
    end
  end

  def humanize(secs)
    return if secs.nil?
    [
      [60, :seconds],
      [60, :minutes],
      [24, :hours],
      [1000, :days]
    ].map do |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    end.compact.reverse.join(' ')
  end

  def get_rating(result, target)
    return if target.nil?
    return if result.nil?
    return 'green' if result < target
    return 'red' if result > target
  end

  def admin?
    current_user.admin
  end
end
