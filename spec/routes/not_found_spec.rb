RSpec.describe 'NotFound Routes', type: :routing do
  it 'GET NotFound #routing_error' do
    expect(get: '/test').to route_to(action: 'routing_error', controller: 'application', not_found: 'test')
  end
end
