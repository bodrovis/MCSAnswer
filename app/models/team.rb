class Team < ApplicationRecord
  has_many :team_games, dependent: :destroy

  validates :title, presence: true
end
