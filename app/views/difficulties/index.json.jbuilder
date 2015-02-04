json.array!(@difficulties) do |difficulty|
  json.extract! difficulty, :id, :name
  json.url difficulty_url(difficulty, format: :json)
end
