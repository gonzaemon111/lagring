RSpec.describe Api::DailyNecessitiesController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/json', Authorization: "Bearer #{token}" } }
  let(:token) { ::Users::GenerateTokenOperator.process(user:) }

  before { token }

  describe 'GET index /api/daily_necessities' do
    subject { get api_daily_necessities_path, headers: }

    context '正常系 200' do
      before { create(:daily_necessity, user:) }

      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['daily_necessities'].size).to eq(user.daily_necessities.size)
        expect(response.parsed_body['daily_necessities'][0]['name']).to eq(user.daily_necessities.first.name)
        expect(response.parsed_body['daily_necessities'][0]['quantity']).to eq(user.daily_necessities.first.quantity)
        expect(response.parsed_body['daily_necessities'][0]['image_url']).to eq(user.daily_necessities.first.image_url)
        expect(response.parsed_body['daily_necessities'][0]['memo']).to eq(user.daily_necessities.first.memo)
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

  describe 'GET show /api/daily_necessities/1' do
    subject { get api_daily_necessity_path(daily_necessity_id), headers: }

    let(:daily_necessity) { create(:daily_necessity, user:) }
    let(:daily_necessity_id) { daily_necessity.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(user.daily_necessities.first.name)
        expect(response.parsed_body['quantity']).to eq(user.daily_necessities.first.quantity)
        expect(response.parsed_body['image_url']).to eq(user.daily_necessities.first.image_url)
        expect(response.parsed_body['memo']).to eq(user.daily_necessities.first.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:daily_necessity_id) { 200_000_000 }

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

  describe 'POST create /api/daily_necessities' do
    subject { post api_daily_necessities_path, headers:, params: }

    let(:params) do
      {
        daily_necessity: {
          name:,
          quantity: 1,
          image_url: '',
          memo: 'メモ'
        }
      }.to_json
    end
    let(:name) { '品名' }

    context '正常系 201' do
      it 'Response Created' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq('品名')
        expect(response.parsed_body['quantity']).to eq(1)
        expect(response.parsed_body['image_url']).to eq('')
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
          expect(response.parsed_body['messages']).to eq(['品名を入力してください。'])
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

  describe 'PUT update /api/daily_necessities/1' do
    subject { put api_daily_necessity_path(daily_necessity_id), headers:, params: }

    let(:daily_necessity) { create(:daily_necessity, user:) }
    let(:daily_necessity_id) { daily_necessity.id }
    let(:params) do
      { daily_necessity: { image_url: 'https://www.jamble.co.jp/upload/save_image/63369_01.jpg' } }.to_json
    end

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(daily_necessity.name)
        expect(response.parsed_body['quantity']).to eq(daily_necessity.quantity)
        expect(response.parsed_body['image_url']).to eq('https://www.jamble.co.jp/upload/save_image/63369_01.jpg')
        expect(response.parsed_body['memo']).to eq(daily_necessity.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:daily_necessity_id) { 200_000_000 }

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
        let(:params) { { daily_necessity: {} }.to_json }

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

  describe 'DELETE destroy /api/daily_necessities/1' do
    subject { delete api_daily_necessity_path(daily_necessity_id), headers: }

    let(:daily_necessity) { create(:daily_necessity, user:) }
    let(:daily_necessity_id) { daily_necessity.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(daily_necessity.name)
        expect(response.parsed_body['quantity']).to eq(daily_necessity.quantity)
        expect(response.parsed_body['image_url']).to eq(daily_necessity.image_url)
        expect(response.parsed_body['memo']).to eq(daily_necessity.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:daily_necessity_id) { 300_000_000 }

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
