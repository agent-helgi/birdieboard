class Score < ApplicationRecord
  belongs_to :round
  belongs_to :user
  belongs_to :approved_by, class_name: "User", optional: true

  has_one_attached :scorecard_image

  STATUSES = %w[draft submitted approved].freeze
  validates :status, inclusion: { in: STATUSES }

  scope :approved, -> { where(status: "approved") }

  def submit!
    update!(status: "submitted")
  end

  def approve!(approver)
    update!(status: "approved", approved_by: approver, approved_at: Time.current)
  end

  def stableford_total
    return nil unless gross_scores.present? && round.course_par.present?

    entry = round.tournament.entries.find_by(user: user)
    hc = entry&.playing_handicap || user.handicap_index&.to_i || 0

    gross_scores.each_with_index.sum do |gross, i|
      next 0 unless gross
      par = round.course_par[i]
      si  = round.course_si[i]
      round.stableford_points(gross, par, si, hc)
    end
  end
end
