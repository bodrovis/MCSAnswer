# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :game

  validates :body, presence: true
  validates :answer, presence: true
  validates :position, numericality: { only_integer: true, greater_than: 0 }, uniqueness: { scope: :game }
  validates :current, uniqueness: { scope: :game }, if: :current?
end
