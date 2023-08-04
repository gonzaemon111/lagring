require 'rails_helper'

RSpec.describe AccessTokenService do
  let(:secret_key) { 'test_secret_key' }
  let(:algorithm) { 'HS256' }
  let(:payload) { { 'user_id' => 1, 'email' => 'user@example.com' } }
  let(:token) { JWT.encode(payload, secret_key, algorithm) }

  before do
    # Rails.application.credentialsをモックしてテスト用のsecret_keyとalgorithmを設定します
    allow(::Rails.application.credentials).to receive_messages(secret_key_base: secret_key, jwt_algorithm: algorithm)
  end

  describe '#generate_token' do
    it 'generates a valid JWT token with the given payload' do
      access_token_service = described_class.new
      generated_token = access_token_service.generate_token(payload)

      decoded_token = JWT.decode(generated_token, secret_key, true, { algorithm: }).first
      expect(decoded_token).to eq(payload)
    end
  end

  describe '#decode' do
    it 'decodes a valid JWT token and returns the payload' do
      access_token_service = described_class.new
      decoded_payload = access_token_service.decode(token)

      expect(decoded_payload).to eq([payload, { 'alg' => 'HS256' }])
    end

    it 'raises an error for an invalid token' do
      access_token_service = described_class.new

      # 無効なトークンを生成してdecodeメソッドがエラーを発生させることを確認します
      invalid_token = 'invalid_token_here'
      expect { access_token_service.decode(invalid_token) }.to raise_error(JWT::DecodeError)
    end
  end
end
