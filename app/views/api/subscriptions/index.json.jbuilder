json.subscriptions do
  json.array! @subscriptions, partial: 'subscription', as: :subscription
end
