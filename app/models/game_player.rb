# frozen_string_literal: true

class GamePlayer < ApplicationRecord
  belongs_to :user
  belongs_to :playing_team

  validates :captain, uniqueness: { scope: :playing_team }, if: :captain?
  validates :user, uniqueness: { scope: :playing_team }
  validate :not_registered, on: :create

  delegate :name, :name_with_email, to: :user

  private

  def not_registered
    return unless self.class.where(user:, playing_team: playing_team.game.playing_teams).any?

    errors.add(:user, 'уже заявлен')
  end
end
