json.array!(@runs) do |run|
  json.extract! run, :id, :duration, :user_id, :toon_id, :difficulty_id, :player_count
  json.url run_url(run, format: :json)
end
