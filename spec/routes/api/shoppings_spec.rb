RSpec.describe 'Api::ShoppingsController Routes', type: :routing do
  it 'GET Api::ShoppingsController #index' do
    expect(get: '/api/shoppings').to route_to(action: 'index', controller: 'api/shoppings', format: :json)
  end

  it 'GET Api::ShoppingsController #show' do
    expect(get: '/api/shoppings/1').to route_to(action: 'show', controller: 'api/shoppings', id: '1', format: :json)
  end

  it 'POST Api::ShoppingsController #create' do
    expect(post: '/api/shoppings').to route_to(action: 'create', controller: 'api/shoppings', format: :json)
  end

  it 'DELETE Api::ShoppingsController #delete' do
    expect(delete: '/api/shoppings/1').to route_to(action: 'destroy', controller: 'api/shoppings', id: '1', format: :json)
  end

  it 'PUT Api::ShoppingsController #update' do
    expect(put: '/api/shoppings/1').to route_to(action: 'update', controller: 'api/shoppings', id: '1', format: :json)
  end
end
