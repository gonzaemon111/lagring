json.shoppings do
  json.array! @shoppings, partial: 'shopping', as: :shopping
end
