RSpec.describe HealthController, type: :request do
  let(:headers) { { 'Content-Type': 'application/json' } }

  describe 'GET #check /' do
    subject { get root_path, headers: }

    it '正常系 200' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #check /health' do
    subject { get health_path, headers: }

    it '正常系 200' do
      subject
      expect(response).to have_http_status(:ok)
    end
  end
end
