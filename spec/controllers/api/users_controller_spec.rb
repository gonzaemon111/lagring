RSpec.describe Api::UsersController, type: :request do
  describe 'GET show /users/:id' do
    subject { get api_user_path(user_id) }

    before { user }

    let!(:user) { create(:user) }
    let!(:user_id) { user.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['id']).to eq(user.id)
        expect(response.parsed_body['name']).to eq(user.name)
        expect(response.parsed_body['provider']).to eq(user.provider)
      end
    end

    context '異常系 404' do
      let!(:user_id) { 100_000_000 }

      it 'Response NotFound' do
        subject
        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['code']).to eq(404)
        expect(response.parsed_body['message']).to eq('データがありません。')
        expect(response.parsed_body['messages']).to eq(['データがありません。'])
      end
    end
  end

  describe 'POST create /users' do
    subject { post api_users_path, params: }

    let(:params) do
      { user: { name: 'テスト', provider: 'Github' } }
    end

    context '正常系 201' do
      it 'Response Created' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['id']).to be_a(::Integer)
        expect(response.parsed_body['name']).to eq('テスト')
        expect(response.parsed_body['provider']).to eq('Github')
      end
    end

    context '異常系 400' do
      let(:params) do
        { user: { name: nil, provider: 'Github' } }
      end

      it 'Response BadRequest' do
        subject
        expect(response).to have_http_status(:bad_request)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['code']).to eq(400)
        expect(response.parsed_body['messages']).to eq(['名前を入力してください。'])
      end
    end
  end
end
