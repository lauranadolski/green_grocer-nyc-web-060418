
# Transform the given cart array into a hash that includes counts for each item.
def consolidate_cart(cart)
  new_cart_hash = {}
  counter = 0
  cart.each do |item_hash|
    if new_cart_hash.include?(item_hash.keys[0])
      counter += 1
    else
      counter = 1
    end
    item_hash.each do |item_name, item_data|
      item_data.each do |key, value|
        new_cart_hash[item_name] = item_data
      end
      new_cart_hash[item_name][:count] = counter
    end
  end
return new_cart_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
# If the coupon doesn't apply to any items, skip it.
    if !cart.include?(coupon[:item])
      next
    end
# If the number of coupon-applicable-items in the cart is greater than or equal to the number of items allowed by the coupon, update the number of items in the cart to subtract those eligible to be purchased with the coupon.
    if cart[coupon[:item]][:count] >= coupon[:num]
      coupon_item_name = coupon[:item].to_s + " W/COUPON"
      if !cart[coupon_item_name]
        cart[coupon_item_name] = {
          price: coupon[:cost],
          clearance: cart[coupon[:item]][:clearance],
          count: 1
        }
      else
        cart[coupon_item_name][:count] += 1
      end
      cart[coupon[:item]][:count] = cart[coupon[:item]][:count] - coupon[:num]
    end
  end
return cart
end

def apply_clearance(cart)
  cart.each do |item, information|
    if cart[item][:clearance] == true
      cart[item][:price] = (cart[item][:price] * 0.8).round(2)
    end
  end
return cart
end

# Calculates total cost of a cart of items and applies discounts and coupons as
# necessary.
def checkout(cart, coupons)
  total_counter = 0.0
  new_cart = cart
  new_cart = consolidate_cart(new_cart)
  new_cart = apply_coupons(new_cart, coupons)
  new_cart = apply_clearance(new_cart)
  new_cart.each do |item, information|
    total_counter += (new_cart[item][:price] * new_cart[item][:count])
  end
  if total_counter > 100.0
    total_counter = total_counter * 0.9
  end
  return total_counter
end
