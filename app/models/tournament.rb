class Tournament < ApplicationRecord
  belongs_to :organiser, class_name: "User"
  has_many :invitations, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :players, through: :entries, source: :user
  has_many :rounds, dependent: :destroy

  FORMATS = %w[stableford pairs matchplay].freeze
  STATES  = %w[draft open active closed].freeze

  validates :name, presence: true
  validates :format, inclusion: { in: FORMATS }
  validates :state,  inclusion: { in: STATES }

  scope :open_to_entries, -> { where(state: %w[open active]) }

  def entry_fee
    entry_fee_pence / 100.0
  end

  def cttp_fee
    cttp_fee_pence / 100.0
  end

  def invited?(user)
    invitations.accepted.exists?(user: user)
  end

  def entered?(user)
    entries.exists?(user: user)
  end
end
