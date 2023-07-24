RSpec.describe Api::DomainsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/json', Authorization: "Bearer #{token}" } }
  let(:token) { ::Users::GenerateTokenOperator.process(user:) }

  before { token }

  describe 'GET index /api/domains' do
    subject { get api_domains_path, headers: }

    context '正常系 200' do
      before { create(:domain, user:) }

      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['domains'].size).to eq(user.domains.size)
        expect(response.parsed_body['domains'][0]['name']).to eq(user.domains.first.name)
        expect(response.parsed_body['domains'][0]['account_name']).to eq(user.domains.first.account_name)
        expect(response.parsed_body['domains'][0]['is_canceled']).to eq(user.domains.first.is_canceled)
        expect(response.parsed_body['domains'][0]['memo']).to eq(user.domains.first.memo)
        expect(response.parsed_body['domains'][0]['provider']).to eq(user.domains.first.provider)
      end
    end

    context '異常系' do
      context 'トークンが不正な時 401' do
        let(:token) { nil }

        it 'Response BadRequest' do
          subject
          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(401)
          expect(response.parsed_body['message']).to eq('権限がありません')
          expect(response.parsed_body['messages']).to eq(['権限がありません'])
        end
      end
    end
  end

  describe 'GET show /api/domains/1' do
    subject { get api_domain_path(domain_id), headers: }

    let(:domain) { create(:domain, user:) }
    let(:domain_id) { domain.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(user.domains.first.name)
        expect(response.parsed_body['account_name']).to eq(user.domains.first.account_name)
        expect(response.parsed_body['is_canceled']).to eq(user.domains.first.is_canceled)
        expect(response.parsed_body['memo']).to eq(user.domains.first.memo)
        expect(response.parsed_body['provider']).to eq(user.domains.first.provider)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:domain_id) { 200_000_000 }

        it 'Response NotFound' do
          subject
          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(404)
          expect(response.parsed_body['message']).to eq('データがありません。')
          expect(response.parsed_body['messages']).to eq(['データがありません。'])
        end
      end

      context 'トークンが不正な時' do
        let(:token) { nil }

        it 'Response BadRequest' do
          subject
          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(401)
          expect(response.parsed_body['message']).to eq('権限がありません')
          expect(response.parsed_body['messages']).to eq(['権限がありません'])
        end
      end
    end
  end

  describe 'POST create /api/domains' do
    subject { post api_domains_path, headers:, params: }

    let(:params) do
      {
        domain: {
          name:,
          account_name: 'hogehoge',
          is_canceled: false,
          memo: 'メモ',
          next_updated_at: nil,
          provider: 'Google Domain'
        }
      }.to_json
    end
    let(:name) { 'ドメイン名' }

    context '正常系 201' do
      it 'Response Created' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq('ドメイン名')
        expect(response.parsed_body['account_name']).to eq('hogehoge')
        expect(response.parsed_body['is_canceled']).to be(false)
        expect(response.parsed_body['memo']).to eq('メモ')
        expect(response.parsed_body['provider']).to eq('Google Domain')
      end
    end

    context '異常系' do
      context 'パラメータが不正な時' do
        let(:name) { nil }

        it 'Response BadRequest' do
          subject
          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(400)
          expect(response.parsed_body['messages']).to eq(['ドメイン名を入力してください。'])
        end
      end

      context 'トークンが不正な時' do
        let(:token) { nil }

        it 'Response BadRequest' do
          subject
          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(401)
          expect(response.parsed_body['message']).to eq('権限がありません')
          expect(response.parsed_body['messages']).to eq(['権限がありません'])
        end
      end
    end
  end

  describe 'PUT update /api/domains/1' do
    subject { put api_domain_path(domain_id), headers:, params: }

    let(:domain) { create(:domain, user:) }
    let(:domain_id) { domain.id }
    let(:params) do
      { domain: { is_canceled: true } }.to_json
    end

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(domain.name)
        expect(response.parsed_body['account_name']).to eq(domain.account_name)
        expect(response.parsed_body['is_canceled']).to be(true)
        expect(response.parsed_body['provider']).to eq(domain.provider)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:domain_id) { 200_000_000 }

        it 'Response NotFound' do
          subject
          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(404)
          expect(response.parsed_body['message']).to eq('データがありません。')
          expect(response.parsed_body['messages']).to eq(['データがありません。'])
        end
      end

      context 'パラメータが不正な時' do
        let(:params) { { domain: {} }.to_json }

        it 'Response BadRequest' do
          subject
          expect(response).to have_http_status(:bad_request)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(400)
          expect(response.parsed_body['message']).to eq('パラメータが不正です。')
        end
      end

      context 'トークンが不正な時' do
        let(:token) { nil }

        it 'Response BadRequest' do
          subject
          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(401)
          expect(response.parsed_body['message']).to eq('権限がありません')
          expect(response.parsed_body['messages']).to eq(['権限がありません'])
        end
      end
    end
  end

  describe 'DELETE destroy /api/domains/1' do
    subject { delete api_domain_path(domain_id), headers: }

    let(:domain) { create(:domain, user:) }
    let(:domain_id) { domain.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(domain.name)
        expect(response.parsed_body['account_name']).to eq(domain.account_name)
        expect(response.parsed_body['is_canceled']).to eq(domain.is_canceled)
        expect(response.parsed_body['provider']).to eq(domain.provider)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:domain_id) { 300_000_000 }

        it 'Response NotFound' do
          subject
          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(404)
          expect(response.parsed_body['message']).to eq('データがありません。')
          expect(response.parsed_body['messages']).to eq(['データがありません。'])
        end
      end

      context 'トークンが不正な時' do
        let(:token) { nil }

        it 'Response BadRequest' do
          subject
          expect(response).to have_http_status(:unauthorized)
          expect(response.parsed_body).to be_a(::Hash)
          expect(response.parsed_body['code']).to eq(401)
          expect(response.parsed_body['message']).to eq('権限がありません')
          expect(response.parsed_body['messages']).to eq(['権限がありません'])
        end
      end
    end
  end
end
