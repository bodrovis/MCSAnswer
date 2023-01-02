# frozen_string_literal: true

class PagesController < ApplicationController
  def search
    authorize :page, :search?
    term = params[:term].to_s.strip
    @pagy, @questions = pagy Question.includes(:game).search_data(term)
  end
end
