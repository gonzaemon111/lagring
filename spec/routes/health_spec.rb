RSpec.describe 'Health Routes', type: :routing do
  it 'GET Health #check' do
    expect(get: '/health').to route_to(action: 'check', controller: 'health')
  end
end
