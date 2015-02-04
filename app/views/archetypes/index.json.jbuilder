json.array!(@archetypes) do |archetype|
  json.extract! archetype, :id, :name
  json.url archetype_url(archetype, format: :json)
end
