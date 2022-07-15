# frozen_string_literal: true

class Game < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :playing_teams, dependent: :destroy
  has_many :answers, dependent: :destroy
  belongs_to :host, class_name: 'User'

  validates :title, presence: true, length: { minimum: 3, maximum: 150 }

  def swap_questions_by(old_pos, new_pos)
    Game.transaction do
      q1 = questions.find_by position: old_pos
      q2 = questions.find_by position: new_pos

      q2.update! position: 0
      q1.update! position: new_pos
      q2.update! position: old_pos
    end
  end

  def current_question
    questions.find_by(current: true)
  end

  def next_question(override_current_question = nil)
    c_question = override_current_question || current_question
    next_position = c_question.present? ? c_question.position + 1 : 1
    questions.find_by(position: next_position)
  end

  def build_next_question
    questions.build position: (questions_count + 1)
  end

  def hosted_by?(user)
    host == user
  end
end
