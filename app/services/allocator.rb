class Allocator


  def initialize
    @current_time = Time.zone.now.to_i
  end

  def allocate(orders, des)
  # reorder the orders based on user's premium account or history or any other parameter
    orders = prioritize_orders orders
    # pick order one by one and assign delivery executives
    orders.collect do |order|
      res = de_assigner(order, des)
      des.delete_if {|de| de[:id] == res[:de_id]}
      res
    end
  end

  private

  def prioritize_orders(orders)
    orders
  end

  def de_assigner(order, des)
    des.sort_by! do |de|
      [
        Haversine.instance.spherical_distance(order[:restaurant_location], de[:current_location]),
        de[:last_order_delivered_time].to_i - @current_time,
        order[:ordered_time].to_i - @current_time
      ]
    end
    {order_id: order[:id], de_id: des[0][:id]}
  end

end
