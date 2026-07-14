class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :organised_tournaments, class_name: "Tournament", foreign_key: :organiser_id, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :tournaments, through: :entries
  has_many :scores, dependent: :destroy

  ROLES = %w[organiser player].freeze
  validates :role, inclusion: { in: ROLES }

  def organiser?
    role == "organiser"
  end

  def full_name
    [ name, surname ].compact.join(" ")
  end
end
