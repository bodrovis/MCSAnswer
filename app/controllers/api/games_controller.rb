# frozen_string_literal: true

module Api
  class GamesController < BaseController
    before_action :require_authentication
    before_action :set_game!
    before_action :authorize_game!
    after_action :verify_authorized

    def alarm
      Game.transaction do
        @game.game_players.find_each { |p| p.update(current: false, answered: false) }
        @game.current_question.update answered: true
        @game.update current_question: nil
      end

      ActionCable.server.broadcast(
        "game_#{@game.id}",
        {
          state: 'finish_question',
          player: current_user.name
        }
      )

      head :ok
    end

    def suggest_answer
      begin
        GamePlayer.transaction do
          game_player = GamePlayer.lock('FOR UPDATE NOWAIT').find_by(game: @game, player: current_user)
          game_player.current = true
          game_player.save!
        end

        ActionCable.server.broadcast(
          "game_#{@game.id}",
          {
            state: 'answer_ready',
            player: current_user.name
          }
        )
      rescue StandardError => e
        Rails.logger.debug e.inspect
      end

      head :ok
    end

    def correct_answer
      current_player, current_score = update_player_score

      ActionCable.server.broadcast(
        "game_#{@game.id}",
        {
          state: 'correct_answer',
          answered_player: current_player.id,
          score: current_score
        }
      )

      head :ok
    end

    def incorrect_answer
      current_player, current_score = update_player_score incorrect: true

      ActionCable.server.broadcast(
        "game_#{@game.id}",
        {
          state: 'incorrect_answer',
          valid_players: @game.game_players.where.not(answered: true).pluck(:id),
          answered_player: current_player.id,
          score: current_score
        }
      )

      head :ok
    end

    def finish_question
      Game.transaction do
        @game.game_players.find_each { |p| p.update(current: false, answered: false) }
        @game.current_question.update answered: true
        @game.update current_question: nil
      end

      ActionCable.server.broadcast(
        "game_#{@game.id}",
        {
          state: 'finish_question'
        }
      )

      head :ok
    end

    private

    def update_player_score(incorrect: false)
      current_player = @game.game_players.current
      sum = @game.current_question.sum
      sum = -sum if incorrect
      current_score = current_player.score + sum
      current_player.update answered: true, current: false, score: current_score

      [current_player, current_score]
    end

    def set_game!
      @game = Game.find params[:id]
    end

    def authorize_game!
      authorize(@game || Game)
    end
  end
end
