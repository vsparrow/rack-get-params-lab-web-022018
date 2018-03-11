class Application


  @@items = ["Apples","Carrots","Pears"]
  @@cart = []  # Create a new class array called @@cart to hold any items in your cart

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)      # Create a new route called /cart to show the items in your cart
      @@cart.each {|item| resp.write "#{item}\n"} if @@cart.size > 0
      resp.write "Your cart is empty" if @@cart.size == 0
    elsif req.path.match(/add/)
      # Create a new route called /add that takes in a GET param with the key item.
      add_item = req.params["item"]
      # STDERR.puts "********#{add_item}||#{req.params}"
      #   This should check to see if that item is in @@items and then add it to the cart if it is.
      if @@items.include?(add_item)
        @@cart << add_item
        # STDERR.puts "GOT HERE TO ADD ITEM::Added #{add_item}"
        resp.write "added #{add_item}"
      #   Otherwise give an error
      else#else inner
        # resp.write "Error item not found "
        resp.write "We don't have that item"
      end#if inner
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end#class

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
