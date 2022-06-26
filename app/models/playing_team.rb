# frozen_string_literal: true

class PlayingTeam < ApplicationRecord
  belongs_to :team
  belongs_to :game
  has_many :game_players, dependent: :destroy
  has_many :users, through: :game_players
  has_many :answers, dependent: :destroy

  delegate :title, to: :team
end
