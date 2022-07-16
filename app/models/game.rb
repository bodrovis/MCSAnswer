# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :playing_teams, dependent: :destroy
  has_many :answers, dependent: :destroy
  belongs_to :host, class_name: 'User'

  validates :title, presence: true, length: { minimum: 3, maximum: 150 }

  def current_question
    questions.find_by(current: true)
  end

  def next_question(override_current_question = nil)
    c_question = override_current_question || current_question
    next_position = c_question.present? ? c_question.position + 1 : 1
    questions.find_by(position: next_position)
  end

  def build_next_question
    questions.build position: (questions_count.to_i + 1)
  end

  def hosted_by?(user)
    host == user
  end
end
