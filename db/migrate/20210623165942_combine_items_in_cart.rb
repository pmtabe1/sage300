class CombineItemsInCart < ActiveRecord::Migration[5.1]
  def up
    # replace multiple items for a single one in cart
    Cart.all.each do |cart|
      # count the number of each item in the cart
      sums = cart.line_items.group(:icitem).sum(:quantity)

      sums.each do |item, quantity|
        if quantity > 1
          # remove individual items
          cart.line_items.where(icitem: item).delete_all

          # replace with a single item
          item = cart.line_items.build(icitem: item)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end

  def down
    # split items with quantity > 1
    LineItem.where("quantity > 1").each do |line_item|
      # add individual items
      line_item.quantity.times do
        LineItem.create(
          cart_id: line_item.cart_id,
          icitem: line_item.icitem,
          quantity: 1
        )
      end
      # remove original item
      line_item.destroy
    end
  end
end
