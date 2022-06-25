# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game!, except: :index
  before_action :authorize_game!
  after_action :verify_authorized

  def index
    @games = Game.where(finished: false).order(created_at: :desc)
  end

  def show; end

  def finish_question
    @game.current_question&.update answered: true
  end

  def next_question
    Game.transaction do
      current_question = @game.current_question
      #current_question&.update current: false, answered: true
      @next_question = @game.next_question current_question

      # if @next_question.present?
      #   @next_question.toggle!(:current)
      # else
      #   @game.update finished: true
      # end
    end

    Turbo::StreamsChannel.broadcast_stream_to(
      @game, 'questions',
      content: self.render(
        template: "games/next_question"
      )
    )
  end

  private

  def set_game!
    @game = Game.includes(:questions).find(params[:id])
  end

  def authorize_game!
    authorize(@game || Game)
  end
end
