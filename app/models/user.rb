# frozen_string_literal: true

class User < ApplicationRecord
  enum role: { basic: 0, moderator: 1, admin: 2 }, _suffix: :role

  has_secure_password validations: false

  has_many :game_players, dependent: :destroy
  has_many :playing_teams, through: :game_players

  validate :password_presence
  validates :password, confirmation: true, allow_blank: true,
                       length: { minimum: 8, maximum: 70 }
  validates :email, presence: true, uniqueness: true, email: true
  validate :password_complexity
  validates :role, presence: true

  before_save :set_gravatar_hash, if: :email_changed?
  before_create :name_from_email, unless: proc { name.present? }

  def in_game(game)
    game_players.joins(playing_team: :game).where(playing_team: { game: }).first
  end

  def participates_in?(game)
    in_game(game).present? || game.hosted_by?(self)
  end

  def guest?
    false
  end

  def name_with_email
    "#{name} (#{email})"
  end

  private

  def name_from_email
    self.name = email.split('@').first
  end

  def set_gravatar_hash
    return if email.blank?

    hash = Digest::MD5.hexdigest email.strip.downcase
    self.gravatar_hash = hash
  end

  def digest(string)
    cost = if ActiveModel::SecurePassword
              .min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    return if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-~])/

    msg = 'слишком простой. 8-70 символов ' \
          'и буквы разного регистра, 1 число и 1 специальный символ.'
    errors.add :password, msg
  end

  def password_presence
    errors.add(:password, :blank) if password_digest.blank?
  end
end
