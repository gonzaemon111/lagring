RSpec.describe Api::SubscriptionsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/json', Authorization: "Bearer #{token}" } }
  let(:token) { ::Users::GenerateTokenOperator.process(user:) }

  before { token }

  describe 'GET index /api/subscriptions' do
    subject { get api_subscriptions_path, headers: }

    context '正常系 200' do
      before { create(:subscription, user:) }

      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['subscriptions'].size).to eq(user.subscriptions.size)
        expect(response.parsed_body['subscriptions'][0]['name']).to eq(user.subscriptions.first.name)
        expect(response.parsed_body['subscriptions'][0]['started_at']).to eq(I18n.l(user.subscriptions.first.started_at, locale: :ja))
        expect(response.parsed_body['subscriptions'][0]['finished_at']).to eq(I18n.l(user.subscriptions.first.finished_at, locale: :ja))
        expect(response.parsed_body['subscriptions'][0]['repeat_frequency']).to eq(user.subscriptions.first.repeat_frequency)
        expect(response.parsed_body['subscriptions'][0]['price']).to eq(user.subscriptions.first.price)
        expect(response.parsed_body['subscriptions'][0]['memo']).to eq(user.subscriptions.first.memo)
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

  describe 'GET show /api/subscriptions/1' do
    subject { get api_subscription_path(subscription_id), headers: }

    let(:subscription) { create(:subscription, user:) }
    let(:subscription_id) { subscription.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(user.subscriptions.first.name)
        expect(response.parsed_body['started_at']).to eq(I18n.l(user.subscriptions.first.started_at))
        expect(response.parsed_body['finished_at']).to eq(I18n.l(user.subscriptions.first.finished_at))
        expect(response.parsed_body['repeat_frequency']).to eq(user.subscriptions.first.repeat_frequency)
        expect(response.parsed_body['price']).to eq(user.subscriptions.first.price)
        expect(response.parsed_body['memo']).to eq(user.subscriptions.first.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:subscription_id) { 200_000_000 }

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

  describe 'POST create /api/subscriptions' do
    subject { post api_subscriptions_path, headers:, params: }

    let(:params) do
      {
        subscription: {
          name:,
          started_at: '2023/07/01 23:03:42',
          finished_at: '2023/08/01',
          repeat_frequency: 'month',
          price: 990,
          memo: 'メモ'
        }
      }.to_json
    end
    let(:name) { '買い物' }

    context '正常系 201' do
      it 'Response Created' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq('買い物')
        expect(response.parsed_body['started_at']).to eq('2023/07/01 23:03:42')
        expect(response.parsed_body['finished_at']).to eq('2023/08/01 00:00:00')
        expect(response.parsed_body['repeat_frequency']).to eq('month')
        expect(response.parsed_body['price']).to eq(990)
        expect(response.parsed_body['memo']).to eq('メモ')
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
          expect(response.parsed_body['messages']).to eq(['サブスクリプション名を入力してください。'])
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

  describe 'PUT upfinished_at /api/subscriptions/1' do
    subject { put api_subscription_path(subscription_id), headers:, params: }

    let(:subscription) { create(:subscription, user:) }
    let(:subscription_id) { subscription.id }
    let(:params) do
      { subscription: { repeat_frequency: 'week' } }.to_json
    end

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(subscription.name)
        expect(response.parsed_body['memo']).to eq(subscription.memo)
        expect(response.parsed_body['price']).to eq(subscription.price)
        expect(response.parsed_body['started_at']).to eq(I18n.l(subscription.started_at))
        expect(response.parsed_body['finished_at']).to eq(I18n.l(subscription.finished_at))
        expect(response.parsed_body['repeat_frequency']).to eq('week')
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:subscription_id) { 400_000_000 }

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
        let(:params) { { subscription: {} }.to_json }

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

  describe 'DELETE destroy /api/subscriptions/1' do
    subject { delete api_subscription_path(subscription_id), headers: }

    let(:subscription) { create(:subscription, user:) }
    let(:subscription_id) { subscription.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(subscription.name)
        expect(response.parsed_body['price']).to eq(subscription.price)
        expect(response.parsed_body['memo']).to eq(subscription.memo)
        expect(response.parsed_body['started_at']).to eq(I18n.l(subscription.started_at))
        expect(response.parsed_body['finished_at']).to eq(I18n.l(subscription.finished_at))
        expect(response.parsed_body['repeat_frequency']).to eq(subscription.repeat_frequency)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:subscription_id) { 300_000_000 }

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
