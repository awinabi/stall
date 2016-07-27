module Stall
  module Payable
    extend ActiveSupport::Concern

    included do
      has_one :payment, dependent: :destroy, inverse_of: :cart
      accepts_nested_attributes_for :payment

      scope :paid, -> {
        joins(:payment).where.not(stall_payments: { paid_at: nil })
      }

      scope :finalized, -> { paid }

      scope :aborted, ->(options = {}) {
        joins('LEFT JOIN stall_payments ON stall_payments.cart_id = stall_product_lists.id')
          .where(stall_payments: { paid_at: nil })
          .older_than(options.fetch(:before, 1.day.ago))
      }
    end
  end
end
