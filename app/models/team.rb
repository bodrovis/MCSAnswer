# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :playing_teams, dependent: :destroy

  validates :title, presence: true
end
