json.licenses do
  json.array! @loading_service.records, :id, :key
end

json.meta do
  json.partial! 'shared/pagination', pagination: @loading_service.pagination
end
