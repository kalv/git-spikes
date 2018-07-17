require 'active_support'

module Service
  extend ActiveSupport::Concern

  included do
    include Virtus.model

    def self.call(*args)
      new(*args).call
    end
  end
end
