# frozen_string_literal: true

class ProcessAnswerJob < ApplicationJob
  queue_as :default

  def perform(question, game, answer_text, user)
    team = user.in_game(game)&.playing_team
    answer = game.answers.build question: question,
                                playing_team: team,
                                body: answer_text

    return unless Pundit.policy(user, answer).create?

    return unless answer.save

    Turbo::StreamsChannel.broadcast_render_to(
      [game, :answers],
      template: 'answers/toggle',
      locals: {
        question:,
        game:,
        team:,
        answer:
      }
    )
  end
end
