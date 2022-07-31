# frozen_string_literal: true

class GameActionsController < ApplicationController
  before_action :set_game!
  before_action :authorize_game!
  after_action :verify_authorized

  def answer_question
    GameActions::AnswerQuestion.call(@game)

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def finish_question
    GameActions::FinishQuestion.call(@game)

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def next_question
    GameActions::NextQuestion.call(@game)

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def start_question
    GameActions::StartQuestion.call(@game)

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  private

  def set_game!
    @game = Game.includes(:questions).find(params[:id])
  end

  def authorize_game!
    authorize(@game || Game)
  end
end
