RSpec.describe 'Api::DailyNecessities Routes', type: :routing do
  it 'GET Api::DailyNecessities #index' do
    expect(get: '/api/daily_necessities').to route_to(action: 'index', controller: 'api/daily_necessities')
  end

  it 'GET Api::DailyNecessities #show' do
    expect(get: '/api/daily_necessities/1').to route_to(action: 'show', controller: 'api/daily_necessities', id: '1')
  end

  it 'POST Api::DailyNecessities #create' do
    expect(post: '/api/daily_necessities').to route_to(action: 'create', controller: 'api/daily_necessities')
  end

  it 'DELETE Api::DailyNecessities #delete' do
    expect(delete: '/api/daily_necessities/1').to route_to(action: 'destroy', controller: 'api/daily_necessities', id: '1')
  end

  it 'PUT Api::DailyNecessities #update' do
    expect(put: '/api/daily_necessities/1').to route_to(action: 'update', controller: 'api/daily_necessities', id: '1')
  end
end
