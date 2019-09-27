class LoanSummary < ApplicationRecord
  self.primary_key = :initial_loan_id

  belongs_to :item
  belongs_to :latest_loan, class_name: "Loan"
  belongs_to :member
  has_one :adjustment, -> { unscope(where: :adjutable_type).where(adjustable_type: 'Loan') }, as: :adjustable

  scope :active_today, ->(date) {
    morning = date.beginning_of_day.utc
    night = date.end_of_day.utc
    where("loan_summaries.ended_at IS NULL OR loan_summaries.ended_at BETWEEN ? AND ?", morning, night)
  }

  scope :active, -> { where(ended_at: nil) }
  scope :recently_returned, -> { where.not(ended_at: nil).where("loan_summaries.ended_at >= ?", Time.current - 7.days) }
  scope :by_end_date, -> { order(ended_at: :asc) }

  def ended?
    ended_at.present?
  end

  def renewed?
    renewal_count > 0
  end

  def readonly?
    true
  end
end
