class Entry < ApplicationRecord
  belongs_to :tournament
  belongs_to :user

  PAYMENT_STATUSES = %w[unpaid paid refunded].freeze
  validates :payment_status, inclusion: { in: PAYMENT_STATUSES }

  scope :paid, -> { where(payment_status: "paid") }

  def paid?
    payment_status == "paid"
  end

  def total_fee_pence
    base = tournament.entry_fee_pence
    base += tournament.cttp_fee_pence if entered_cttp_front
    base += tournament.cttp_fee_pence if entered_cttp_back
    base
  end
end
