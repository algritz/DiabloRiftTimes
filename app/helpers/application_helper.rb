module ApplicationHelper
  def get_archetype(num)
    Archetype.where(["id = ?", num]).first[:name]
  end

  def get_toon_name(num)
    Toon.where(["id = ?", num]).first[:name]
  end

  def get_difficulty_name(num)
    Difficulty.where(["id =?", num]).first[:name]
  end

  def get_player_count(num)
    if num == 1 then
      "Solo"
    else
    num
    end
  end

  def humanize(secs)
    if secs != nil && secs.class == Fixnum then

      [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
        if secs > 0
          secs, n = secs.divmod(count)
          "#{n.to_i} #{name}"
        end
      }.compact.reverse.join(' ')
    else
      "N/A"
    end
  end

  def get_rating(result, target)
  
    if result && target != nil then
      if result <= target then
        "green"
      else
        "red"
      end
    end
  end

end
