RSpec.describe Api::ChecklistsController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/json', Authorization: "Bearer #{token}" } }
  let(:token) { ::Users::GenerateTokenOperator.process(user:) }

  before { token }

  describe 'GET index /api/checklists' do
    subject { get api_checklists_path, headers: }

    context '正常系 200' do
      before { create(:checklist, user:) }

      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['checklists'].size).to eq(user.checklists.size)
        expect(response.parsed_body['checklists'][0]['name']).to eq(user.checklists.first.name)
        puts I18n.l(user.checklists.first.date, locale: :ja)
        expect(response.parsed_body['checklists'][0]['date']).to eq(I18n.l(user.checklists.first.date, locale: :ja))
        expect(response.parsed_body['checklists'][0]['repeat_frequency']).to eq(user.checklists.first.repeat_frequency)
        expect(response.parsed_body['checklists'][0]['memo']).to eq(user.checklists.first.memo)
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

  describe 'GET show /api/checklists/1' do
    subject { get api_checklist_path(checklist_id), headers: }

    let(:checklist) { create(:checklist, user:) }
    let(:checklist_id) { checklist.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(user.checklists.first.name)
        expect(response.parsed_body['date']).to eq(I18n.l(user.checklists.first.date))
        expect(response.parsed_body['repeat_frequency']).to eq(user.checklists.first.repeat_frequency)
        expect(response.parsed_body['memo']).to eq(user.checklists.first.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:checklist_id) { 200_000_000 }

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

  describe 'POST create /api/checklists' do
    subject { post api_checklists_path, headers:, params: }

    let(:params) do
      {
        checklist: {
          name:,
          date: '2023/08/01',
          repeat_frequency: 'none',
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
        expect(response.parsed_body['date']).to eq('2023/08/01')
        expect(response.parsed_body['repeat_frequency']).to eq('none')
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
          expect(response.parsed_body['messages']).to eq(['チェック名を入力してください。'])
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

  describe 'PUT update /api/checklists/1' do
    subject { put api_checklist_path(checklist_id), headers:, params: }

    let(:checklist) { create(:checklist, user:) }
    let(:checklist_id) { checklist.id }
    let(:params) do
      { checklist: { repeat_frequency: 'day' } }.to_json
    end

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(checklist.name)
        expect(response.parsed_body['date']).to eq(I18n.l(checklist.date))
        expect(response.parsed_body['repeat_frequency']).to eq('day')
        expect(response.parsed_body['provider']).to eq(checklist.provider)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:checklist_id) { 400_000_000 }

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
        let(:params) { { checklist: {} }.to_json }

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

  describe 'DELETE destroy /api/checklists/1' do
    subject { delete api_checklist_path(checklist_id), headers: }

    let(:checklist) { create(:checklist, user:) }
    let(:checklist_id) { checklist.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(checklist.name)
        expect(response.parsed_body['date']).to eq(I18n.l(checklist.date))
        expect(response.parsed_body['repeat_frequency']).to eq(checklist.repeat_frequency)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:checklist_id) { 300_000_000 }

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
