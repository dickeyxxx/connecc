require 'net/http'
require 'uri'
require 'google4r/checkout'
require 'hpricot'

module Google
  class CheckoutHandler
    attr_accessor :serial_number

    def initialize(serial_number)
      self.serial_number = serial_number
    end

    # This is called by delayed job from the google order controller
    def perform
      # Set up the server we're going to talk to
      url = URI.parse(GOOGLE_CHECKOUT_NOTIFICATION_HISTORY_URL)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # Set up the headers for the request (crazy base64 madness is per the api spec)
      header = {
        "Authorization" => "Basic " + Base64.encode64("#{ ENV['CONNECC_GOOGLE_MERCHANT_ID'] }:#{ ENV['CONNECC_GOOGLE_MERCHANT_KEY']}"),
        "Content-Type" => "application/xml;charset=UTF-8",
          "Accept" => "application/xml;charset=UTF-8"
      }

      # create the request
      req = Net::HTTP::Post.new(url.path, header)

      # xml we're going to send
      req.body = "
      <notification-history-request xmlns=\"http://checkout.google.com/schema/2\">
        <serial-number>#{ serial_number }</serial-number>
      </notification-history-request>
      "

      # Make the request
      res = http.start { |http| http.request(req) }

      # Error out if not a success
      unless res.kind_of? Net::HTTPSuccess
        res.error!
      end

      # show the log of the xml returned
      puts res.body

      # Set up our parser
      frontend = Google4R::Checkout::Frontend.new(FRONTEND_CONFIGURATION)
      frontend.tax_table_factory = TaxTableFactory.new
      handler = frontend.create_notification_handler

      # parse the data
      begin
        notification = handler.handle(res.body)
      rescue Google4R::Checkout::UnknownNotificationType => e
        render :text => "ignoring unknown notification type", :status => 200
        return
      end

      hpricot = Hpricot(res.body)

      # Find out what type of notification it is and handle it accordingly
      if notification.kind_of? Google4R::Checkout::NewOrderNotification
        order = GoogleOrder.create! do |o|
          o.address1 = notification.buyer_shipping_address.address1
          o.address2 = notification.buyer_shipping_address.address2
          o.city = notification.buyer_shipping_address.city
          o.postal_code = notification.buyer_shipping_address.postal_code
          o.region = notification.buyer_shipping_address.region
          o.google_order_number = notification.google_order_number
          o.user_id = notification.shopping_cart.private_data['user_id']
          o.first_name = notification.shopping_cart.private_data['first_name']
          o.last_name = notification.shopping_cart.private_data['last_name']
          o.company_name = notification.shopping_cart.private_data['company_name']
        end
        order.add_cards(notification.shopping_cart.private_data['cards_amount'].to_i)
      elsif notification.kind_of? Google4R::Checkout::AuthorizationAmountNotification
        order = Order.find_by_google_order_number(notification.google_order_number)
        order.charge(notification.authorization_amount) if order
      end
    end
  end
  class TaxTableFactory
    def effective_tax_tables_at(time)
      [ Google4R::Checkout::TaxTable.new(false) ]
    end
  end
end
