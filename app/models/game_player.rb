class GamePlayer < ApplicationRecord
  belongs_to :user
  belongs_to :team_game

  validates :captain, uniqueness: { scope: :team_game }, if: :captain?
  validates :user, uniqueness: { scope: :team_game }
  validate :not_registered, on: :create

  delegate :name, :name_with_email, to: :user

  private

  def not_registered
    return unless self.class.where(user: self.user, team_game: self.team_game.game.team_games).any?

    errors.add(:user, "уже заявлен")
  end
end
