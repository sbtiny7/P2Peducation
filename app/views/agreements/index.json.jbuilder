json.array!(@agreements) do |agreement|
  json.extract! agreement, :id, :detail
  json.url agreement_url(agreement, format: :json)
end
