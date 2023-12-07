class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :orders
  has_many :addresses

  validates :first_name, :last_name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    # If you have attributes that should not be searchable, exclude them here
    super - ['encrypted_password', 'reset_password_token']
  end

  # Specify which associations should be searchable
  def self.ransackable_associations(auth_object = nil)
    # If there are associations like :passwords, exclude them here
    super - ['some_sensitive_association']
  end

  def stripe_customer
    return Stripe::Customer.retrieve(stripe_customer_id) if stripe_customer_id

    customer = Stripe::Customer.create(email: email)
    update(stripe_customer_id: customer.id)
    customer
  end
end
