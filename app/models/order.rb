require 'active_support/secure_random'
require 'google4r/checkout'

class Order < ActiveRecord::Base
  before_validation :get_missing_data

  after_create :start_activation, :generate_cards
  before_update :update_cards

  belongs_to :user
  has_many :cards
  belongs_to :buyer_billing_address, :class_name => 'Address'
  belongs_to :buyer_shipping_address, :class_name => 'Address'

  validates :type, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :email, :presence => true
  validates :cards_amount, :presence => true

  def ship
    self.shipped = true
    self.save!
  end

  def charge_and_ship
    frontend = Google4R::Checkout::Frontend.new(FRONTEND_CONFIGURATION)
    frontend.tax_table_factory = TaxTableFactory.new
    command = frontend.create_charge_and_ship_order_command
    command.google_order_number = self.google_order_number
    command.send_to_google_checkout
    self.shipped = true
    self.save!
  end

  def to_s
    "Order #{ id }"
  end

  def name
    "#{ self.first_name } #{ self.last_name }"
  end

  def email_address_with_name
    "#{ self.name } <#{ self.email }>"
  end

  protected

  def get_missing_data
    self.first_name = self.user.first_name unless self.first_name
    self.last_name = self.user.last_name unless self.last_name
    self.email = self.user.email unless self.email
    self.buyer_billing_address = self.buyer_shipping_address unless self.buyer_billing_address
  end

  def generate_cards
    cards_amount.times do
      cards << Card.new
    end
    self.save!
  end

  def update_cards
    old = Order.find(self.id)
    unless old.cards_amount == self.cards_amount
      cards.each { |c| c.destroy }
      cards_amount.times do
        cards << Card.new
      end
    end
  end

  def start_activation
    unless self.user
      # first try to find a user
      self.user = User.find_by_email(self.buyer_shipping_address.email)
      self.user = User.find_by_email(self.buyer_billing_address.email) unless self.user
      unless user
        # No user found, send notification and await activation
        self.activation_string = ActiveSupport::SecureRandom.hex(16)
        OrderNotifier.activation(self).deliver
      end
    end
  end

end

class TaxTableFactory
  def effective_tax_tables_at(time)
    [ Google4R::Checkout::TaxTable.new(false) ]
  end
end
