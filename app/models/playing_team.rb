# frozen_string_literal: true

class PlayingTeam < ApplicationRecord
  belongs_to :team
  belongs_to :game, counter_cache: true
  has_many :game_players, dependent: :destroy
  has_many :users, through: :game_players
  has_many :answers, dependent: :destroy

  delegate :title, to: :team

  validates :total_answered, numericality: { only_integer: true, greater_than: -1 }

  scope :game_published_finished, lambda { |count = nil|
    query = joins(:game).where(games: { published: true, finished: true })
                        .order('games.starts_at DESC, games.created_at DESC')
    query = query.limit(count) unless count.nil?
    query
  }
end
