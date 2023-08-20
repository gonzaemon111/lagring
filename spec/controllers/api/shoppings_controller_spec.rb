RSpec.describe Api::ShoppingsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/json', Authorization: "Bearer #{token}" } }
  let(:token) { ::Users::GenerateTokenOperator.process(user:) }

  before { token }

  describe 'GET index /api/shoppings' do
    subject { get api_shoppings_path, headers: }

    context '正常系 200' do
      before { create(:shopping, user:) }

      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['shoppings'].size).to eq(user.shoppings.size)
        expect(response.parsed_body['shoppings'][0]['name']).to eq(user.shoppings.first.name)
        expect(response.parsed_body['shoppings'][0]['image_url']).to eq(user.shoppings.first.image_url)
        expect(response.parsed_body['shoppings'][0]['url']).to eq(user.shoppings.first.url)
        expect(response.parsed_body['shoppings'][0]['shop']).to eq(user.shoppings.first.shop)
        expect(response.parsed_body['shoppings'][0]['is_bought']).to eq(user.shoppings.first.is_bought)
        expect(response.parsed_body['shoppings'][0]['price']).to eq(user.shoppings.first.price)
        expect(response.parsed_body['shoppings'][0]['memo']).to eq(user.shoppings.first.memo)
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

  describe 'GET show /api/shoppings/1' do
    subject { get api_shopping_path(shopping_id), headers: }

    let(:shopping) { create(:shopping, user:) }
    let(:shopping_id) { shopping.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(user.shoppings.first.name)
        expect(response.parsed_body['url']).to eq(user.shoppings.first.url)
        expect(response.parsed_body['image_url']).to eq(user.shoppings.first.image_url)
        expect(response.parsed_body['shop']).to eq(user.shoppings.first.shop)
        expect(response.parsed_body['is_bought']).to eq(user.shoppings.first.is_bought)
        expect(response.parsed_body['price']).to eq(user.shoppings.first.price)
        expect(response.parsed_body['memo']).to eq(user.shoppings.first.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:shopping_id) { 200_000_000 }

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

  describe 'POST create /api/shoppings' do
    subject { post api_shoppings_path, headers:, params: }

    let(:params) do
      {
        shopping: {
          name:,
          url: 'https://amzn.asia/d/d3I41Ej',
          image_url: 'https://m.media-amazon.com/images/I/71j+nzsS4DS._AC_SX679_.jpg',
          shop: 'Amazon',
          price: 990,
          memo: 'メモ'
        }
      }.to_json
    end
    let(:name) { 'ティッシュ' }

    context '正常系 201' do
      it 'Response Created' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq('ティッシュ')
        expect(response.parsed_body['url']).to eq('https://amzn.asia/d/d3I41Ej')
        expect(response.parsed_body['image_url']).to eq('https://m.media-amazon.com/images/I/71j+nzsS4DS._AC_SX679_.jpg')
        expect(response.parsed_body['is_bought']).to eq(false)
        expect(response.parsed_body['shop']).to eq('Amazon')
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
          expect(response.parsed_body['messages']).to eq(['買うものを入力してください。'])
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

  describe 'PUT upfinished_at /api/shoppings/1' do
    subject { put api_shopping_path(shopping_id), headers:, params: }

    let(:shopping) { create(:shopping, user:) }
    let(:shopping_id) { shopping.id }
    let(:params) do
      { shopping: { is_bought: true } }.to_json
    end

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(shopping.name)
        expect(response.parsed_body['memo']).to eq(shopping.memo)
        expect(response.parsed_body['price']).to eq(shopping.price)
        expect(response.parsed_body['url']).to eq(shopping.url)
        expect(response.parsed_body['image_url']).to eq(shopping.image_url)
        expect(response.parsed_body['shop']).to eq(shopping.shop)
        expect(response.parsed_body['is_bought']).to eq(true)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:shopping_id) { 400_000_000 }

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
        let(:params) { { shopping: {} }.to_json }

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

  describe 'DELETE destroy /api/shoppings/1' do
    subject { delete api_shopping_path(shopping_id), headers: }

    let(:shopping) { create(:shopping, user:) }
    let(:shopping_id) { shopping.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(shopping.name)
        expect(response.parsed_body['memo']).to eq(shopping.memo)
        expect(response.parsed_body['price']).to eq(shopping.price)
        expect(response.parsed_body['url']).to eq(shopping.url)
        expect(response.parsed_body['image_url']).to eq(shopping.image_url)
        expect(response.parsed_body['shop']).to eq(shopping.shop)
        expect(response.parsed_body['is_bought']).to eq(shopping.is_bought)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:shopping_id) { 300_000_000 }

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
