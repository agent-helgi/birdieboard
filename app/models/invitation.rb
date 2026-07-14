class Invitation < ApplicationRecord
  belongs_to :tournament
  belongs_to :user, optional: true

  STATUSES = %w[pending accepted declined].freeze
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :status, inclusion: { in: STATUSES }
  validates :token, presence: true, uniqueness: true

  scope :pending,  -> { where(status: "pending") }
  scope :accepted, -> { where(status: "accepted") }

  before_validation :generate_token, on: :create

  def accept!(user)
    update!(status: "accepted", user: user, accepted_at: Time.current)
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end
end
