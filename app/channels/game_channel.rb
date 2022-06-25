# frozen_string_literal: true

class GameChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find params['game']

    reject if game.blank?

    stream_from("game_#{game.id}")
  end

  def show_question(data)
    game = Game.find data['game']
    question = game.questions.find data['question']

    unless !game.finished? && game.hosted_by?(current_user) && game.current_question.blank? && !question.answered?
      return
    end

    game.update current_question: question

    ActionCable.server.broadcast(
      "game_#{game.id}",
      {
        state: 'next_question',
        body: question.body,
        id: question.id
      }
    )
  end

  def start(data)
    game = Game.find data['game']
    question = game.questions.find data['question']

    unless !game.finished? && game.hosted_by?(current_user) && !question.answered? && game.current_question == question
      return
    end

    ActionCable.server.broadcast(
      "game_#{game.id}",
      {
        state: 'answer_click'
      }
    )
  end

  def show_answer(data)
    game = Game.find data['game']
    question = game.questions.find data['question']

    return unless !game.finished? && game.hosted_by?(current_user)

    ActionCable.server.broadcast(
      "game_#{game.id}",
      {
        state: 'question_show',
        answer: question.answer
      }
    )
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
