module Stall
  class LineItemsController < Stall::ApplicationController
    def create
      if service.call
        @quantity = params[:line_item][:quantity].to_i
        @line_item = service.line_item
        # Allow subclasses to hook into successful product list add
        yield(true) if block_given?
        # We do not render if the yield bock already has done it
        render partial: 'added' unless response_body
      else
        @line_item = service.line_item
        # Allow subclasses to hook into failed product list add
        yield(false) if block_given?
        # We do not render if the yield bock already has done it
        render partial: 'add_error' unless response_body
      end
    end

    private

    def product_list
      fail NotImplementedError, 'Override #product_list in subclass'
    end

    def service
      fail NotImplementedError, 'Override #service in subclass'
    end
  end
end
