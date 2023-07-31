RSpec.describe 'Api::SubscriptionsController Routes', type: :routing do
  it 'GET Api::SubscriptionsController #index' do
    expect(get: '/api/subscriptions').to route_to(action: 'index', controller: 'api/subscriptions', format: :json)
  end

  it 'GET Api::SubscriptionsController #show' do
    expect(get: '/api/subscriptions/1').to route_to(action: 'show', controller: 'api/subscriptions', id: '1', format: :json)
  end

  it 'POST Api::SubscriptionsController #create' do
    expect(post: '/api/subscriptions').to route_to(action: 'create', controller: 'api/subscriptions', format: :json)
  end

  it 'DELETE Api::SubscriptionsController #delete' do
    expect(delete: '/api/subscriptions/1').to route_to(action: 'destroy', controller: 'api/subscriptions', id: '1', format: :json)
  end

  it 'PUT Api::SubscriptionsController #update' do
    expect(put: '/api/subscriptions/1').to route_to(action: 'update', controller: 'api/subscriptions', id: '1', format: :json)
  end
end
