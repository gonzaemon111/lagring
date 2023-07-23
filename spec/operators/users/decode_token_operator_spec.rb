require 'rails_helper'

RSpec.describe Users::DecodeTokenOperator do
  describe '.process' do
    let(:service) { instance_double(::AccessTokenService) }

    context 'with a valid token' do
      let(:valid_token) { 'valid_token_here' }
      let(:user_payload) { { email: 'user@example.com', provider: 'example', exp: Time.current.to_i + 3600 } }

      before do
        # テスト用にAccessTokenServiceをモックします
        allow(::AccessTokenService).to receive(:new).and_return(service)
        allow(service).to receive(:decode).with(valid_token).and_return([user_payload])
      end

      it 'returns the user if the token is valid' do
        allow(::User).to receive(:find_by).with(email: user_payload[:email], provider: user_payload[:provider]).and_return(::User.new)
        expect(::User).to receive(:find_by).with(email: user_payload[:email], provider: user_payload[:provider])
        user = described_class.process(token: valid_token)
        expect(user).to be_instance_of(::User)
      end
    end

    context 'with an invalid token' do
      let(:invalid_token) { 'invalid_token_here' }

      before do
        allow(::AccessTokenService).to receive(:new).and_return(service)
        allow(service).to receive(:decode).with(invalid_token).and_return(nil)
      end

      it 'raises UnauthorizedError if the token is invalid' do
        expect { described_class.process(token: invalid_token) }.to raise_error(::UnauthorizedError, 'トークンが不正です')
      end
    end

    context 'with an expired token' do
      let(:expired_token) { 'expired_token_here' }
      let(:user_payload) { { email: 'user@example.com', provider: 'example', exp: Time.current.to_i - 3600 } }

      before do
        allow(::AccessTokenService).to receive(:new).and_return(service)
        allow(service).to receive(:decode).with(expired_token).and_return([user_payload])
      end

      it 'raises UnauthorizedError if the token is expired' do
        expect { described_class.process(token: expired_token) }.to raise_error(::UnauthorizedError, 'トークンの有効期限が切れています')
      end
    end

    context 'with a valid token but no user found' do
      let(:valid_token) { 'valid_token_here' }
      let(:user_payload) { { email: 'nonexistent_user@example.com', provider: 'example', exp: Time.current.to_i + 3600 } }

      before do
        allow(::AccessTokenService).to receive(:new).and_return(service)
        allow(service).to receive(:decode).with(valid_token).and_return([user_payload])
        allow(::User).to receive(:find_by).and_return(nil)
      end

      it 'raises NotFoundError if the user does not exist' do
        expect { described_class.process(token: valid_token) }.to raise_error(::NotFoundError, 'ユーザーが存在しません')
      end
    end
  end
end
