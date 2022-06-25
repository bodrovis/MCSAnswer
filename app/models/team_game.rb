# frozen_string_literal: true

class TeamGame < ApplicationRecord
  belongs_to :team
  belongs_to :game
  has_many :game_players, dependent: :destroy
  has_many :users, through: :game_players

  delegate :title, to: :team
end
