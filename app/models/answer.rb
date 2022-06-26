# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :playing_team
  belongs_to :game

  validates :question, uniqueness: { scope: :playing_team }
  validates :body, length: { maximum: 500 }, allow_blank: true
end
