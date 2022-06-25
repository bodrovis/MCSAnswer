# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    def authorize(record, query = nil)
      super([:api, record], query)
    end
  end
end
