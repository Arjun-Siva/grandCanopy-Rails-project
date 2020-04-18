class ApplicationController < ActionController::Base
  @@cart = []

  def get_cart
    return @@cart
  end

  def put_cart(new_item)
    @@cart.push(new_item)
  end
end
