module Stall
  module Models
    module Shipment
      extend ActiveSupport::Concern

      included do
        self.table_name = 'stall_shipments'

        include Stall::Priceable

        belongs_to :cart
        belongs_to :shipping_method

        store_accessor :data, :tracking_code

        monetize :eot_price_cents, :price_cents,
                 with_model_currency: :currency, allow_nil: true

        enum state: { pending: 0, shipped: 1 }
      end

      def currency
        cart.try(:currency) || Money.default_currency
      end
    end
  end
end
