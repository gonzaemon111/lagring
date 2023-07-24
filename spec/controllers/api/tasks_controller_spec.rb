RSpec.describe Api::TasksController, type: :request do
  let(:user) { create(:user) }
  let(:headers) { { 'Content-Type': 'application/json', Authorization: "Bearer #{token}" } }
  let(:token) { ::Users::GenerateTokenOperator.process(user:) }

  before { token }

  describe 'GET index /api/tasks' do
    subject { get api_tasks_path, headers: }

    context '正常系 200' do
      before { create(:task, user:) }

      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['tasks'].size).to eq(user.tasks.size)
        expect(response.parsed_body['tasks'][0]['name']).to eq(user.tasks.first.name)
        expect(response.parsed_body['tasks'][0]['category_name']).to eq(user.tasks.first.category_name)
        expect(response.parsed_body['tasks'][0]['memo']).to eq(user.tasks.first.memo)
        # expect(response.parsed_body['tasks'][0]['is_canceled']).to eq(user.tasks.first.is_canceled)
        # expect(response.parsed_body['tasks'][0]['provider']).to eq(user.tasks.first.provider)
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

  describe 'GET show /api/tasks/1' do
    subject { get api_task_path(task_id), headers: }

    let(:task) { create(:task, user:) }
    let(:task_id) { task.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(user.tasks.first.name)
        expect(response.parsed_body['category_name']).to eq(user.tasks.first.category_name)
        # expect(response.parsed_body['is_canceled']).to eq(user.tasks.first.is_canceled)
        expect(response.parsed_body['memo']).to eq(user.tasks.first.memo)
        # expect(response.parsed_body['provider']).to eq(user.tasks.first.provider)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:task_id) { 200_000_000 }

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

  describe 'POST create /api/tasks' do
    subject { post api_tasks_path, headers:, params: }

    let(:params) do
      {
        task: {
          name:,
          category_name: 'hogehoge',
          is_canceled: false,
          memo: 'メモ',
          next_updated_at: nil,
          provider: 'Google Domain'
        }
      }.to_json
    end
    let(:name) { 'タスク名' }

    context '正常系 201' do
      it 'Response Created' do
        subject
        expect(response).to have_http_status(:created)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq('タスク名')
        expect(response.parsed_body['category_name']).to eq('hogehoge')
        # expect(response.parsed_body['is_canceled']).to eq(false)
        expect(response.parsed_body['memo']).to eq('メモ')
        # expect(response.parsed_body['provider']).to eq('Google Domain')
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
          expect(response.parsed_body['messages']).to eq(['タスク名を入力してください。'])
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

  describe 'PUT update /api/tasks/1' do
    subject { put api_task_path(task_id), headers:, params: }

    let(:task) { create(:task, user:) }
    let(:task_id) { task.id }
    let(:params) do
      { task: { is_canceled: true } }.to_json
    end

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(task.name)
        expect(response.parsed_body['category_name']).to eq(task.category_name)
        # expect(response.parsed_body['is_canceled']).to eq(true)
        expect(response.parsed_body['memo']).to eq(task.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:task_id) { 200_000_000 }

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
        let(:params) { { task: {} }.to_json }

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

  describe 'DELETE destroy /api/tasks/1' do
    subject { delete api_task_path(task_id), headers: }

    let(:task) { create(:task, user:) }
    let(:task_id) { task.id }

    context '正常系 200' do
      it 'Response OK' do
        subject
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to be_a(::Hash)
        expect(response.parsed_body['name']).to eq(task.name)
        expect(response.parsed_body['category_name']).to eq(task.category_name)
        # expect(response.parsed_body['is_canceled']).to eq(task.is_canceled)
        expect(response.parsed_body['memo']).to eq(task.memo)
      end
    end

    context '異常系' do
      context 'IDが存在しない場合' do
        let(:task_id) { 300_000_000 }

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
