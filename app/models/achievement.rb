# frozen_string_literal: true

class Achievement < ApplicationRecord
  has_many :achievement_ownables, dependent: :destroy
  has_many :teams, through: :achievement_ownables, source: :ownable, source_type: 'Team'

  validates :title, presence: true
  validates :file_data, presence: true
end
