# frozen_string_literal: true

class AchievementOwnable < ApplicationRecord
  belongs_to :achievement
  belongs_to :ownable, polymorphic: true
end
