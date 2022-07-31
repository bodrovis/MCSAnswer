# frozen_string_literal: true

class ProcessAnswerJob < ApplicationJob
  queue_as :default

  def perform(question, game, answer_text, user)
    Answers::ProcessService.call question, game, answer_text, user
  end
end
