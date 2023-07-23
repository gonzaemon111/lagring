module Users
  class GenerateTokenOperator
    attr_reader :user, :exp

    private_class_method :new

    def self.process(user:)
      new(user).process
    end

    def initialize(user)
      @user = user
      @exp = 10.minutes.since.to_i
    end

    def process
      ::AccessTokenService.new.generate_token({
        email: user.email,
        provider: user.provider,
        exp:
      })
    end
  end
end
