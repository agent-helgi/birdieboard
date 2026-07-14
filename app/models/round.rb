class Round < ApplicationRecord
  belongs_to :tournament
  has_many :scores, dependent: :destroy

  FORMATS = %w[stableford pairs matchplay].freeze
  validates :day_number, presence: true, uniqueness: { scope: :tournament_id }
  validates :format, inclusion: { in: FORMATS }

  def total_par
    Array(course_par).sum
  end

  # Stableford points for one hole
  def stableford_points(gross, par, si, playing_handicap)
    strokes = (playing_handicap * si / 18.0).ceil
    net = gross - strokes
    points = 2 + par - net
    [ points, 0 ].max
  end
end
