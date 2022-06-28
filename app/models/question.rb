# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :game
  has_many :answers, dependent: :destroy

  validates :body, presence: true
  validates :answer, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :game }
  validates :current, uniqueness: { scope: :game }, if: :current?

  def answer_by!(team)
    params = { playing_team: team, game: }

    if answered?
      answers.find_or_create_by params
    else
      answers.find_by params
    end
  end
end
