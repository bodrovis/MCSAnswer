# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :game, counter_cache: true
  acts_as_list scope: :game, sequential_updates: false
  has_many :answers, dependent: :destroy

  validates :body, presence: true
  validates :answer, presence: true
  validates :position, numericality: { only_integer: true, greater_than: -1 }, uniqueness: { scope: :game }
  validates :current, uniqueness: { scope: :game }, if: :current?

  def answer_by!(team)
    answers.find_by playing_team: team, game:
  end

  def answered_by?(team)
    answers.find_by(playing_team: team, game:).present?
  end
end
