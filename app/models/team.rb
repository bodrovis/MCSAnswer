# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :playing_teams, dependent: :destroy

  validates :title, presence: true
  has_many :achievement_ownables, as: :ownable, dependent: :destroy
  has_many :achievements, through: :achievement_ownables
end
