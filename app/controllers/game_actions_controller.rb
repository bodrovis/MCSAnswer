# frozen_string_literal: true

class GameActionsController < ApplicationController
  before_action :set_game!
  before_action :authorize_game!
  after_action :verify_authorized

  def answer_question
    @current_question = @game.current_question
    @current_question.update answered: true

    broadcast [@game, 'questions'], 'game_actions/answer',
              locals: { current_question: @current_question, game: @game }

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def finish_question
    broadcast [@game, 'questions'], 'game_actions/finish',
              locals: { game: @game }

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def next_question
    Game.transaction do
      current_question = @game.current_question
      current_question&.update current: false
      @next_question = @game.next_question current_question

      if @next_question.present?
        @next_question.toggle!(:current) # rubocop:disable Rails/SkipsModelValidations
      else
        @game.update finished: true
      end
    end

    broadcast [@game, 'questions'], 'game_actions/next',
              locals: { next_question: @next_question, game: @game }

    respond_to do |format|
      format.turbo_stream { head(:ok) }
    end
  end

  def start_question
    @game.update question_ends_at: 60.seconds.from_now

    broadcast [@game, 'questions'], 'game_actions/start',
              locals: { game: @game }

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
