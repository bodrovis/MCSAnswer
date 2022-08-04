# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_game!
  after_action :verify_authorized

  def index
    @questions = @game.questions.order position: :asc
    authorize @questions.first
  end

  private

  def set_game!
    @game = Game.find params[:game_id]
  end
end