# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    before_action :require_authentication

    def authorize(record, query = nil)
      super([:admin, record], query)
    end
  end
end
