require 'rails_helper'

RSpec.describe Users::GenerateTokenOperator do
  describe '.process' do
    let(:user) do
      instance_double(::User, email: 'user@example.com', provider: 'example')
    end

    it 'calls AccessTokenService to generate a token with the correct payload' do
      # 生成されたトークンのペイロードを検証するためにAccessTokenServiceをモックします
      access_token_service = instance_double(::AccessTokenService)
      allow(::AccessTokenService).to receive(:new).and_return(access_token_service)
      expect(access_token_service).to receive(:generate_token).with({
        email: user.email,
        provider: user.provider,
        exp: kind_of(Integer) # expはInteger型であることを確認します
      })

      described_class.process(user:)
    end

    it 'returns the generated token' do
      # トークン生成の結果を返すようにAccessTokenServiceをモックします
      generated_token = 'generated_token_here'
      access_token_service = instance_double(::AccessTokenService, generate_token: generated_token)
      allow(::AccessTokenService).to receive(:new).and_return(access_token_service)

      result = described_class.process(user:)
      expect(result).to eq(generated_token)
    end
  end
end
