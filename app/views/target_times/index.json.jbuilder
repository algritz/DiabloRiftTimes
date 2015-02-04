json.array!(@target_times) do |target_time|
  json.extract! target_time, :id, :target_time, :difficulty_id, :player_count
  json.url target_time_url(target_time, format: :json)
end
