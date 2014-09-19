class Hub < ActiveRecord::Base
  has_many :transactions
  before_save :associate_transactions

  ONLY_NUMBERS = /\A[0-9]+\z/

  validates :name, length: { maximum: 50 }
  validates :type, presence: true
  validates :location_id, presence: true, uniqueness: true, numericality: { only_integer: true}
  validates :latitude, numericality: { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90}, allow_nil: true
  validates :longitude, numericality: { :greater_than_or_equal_to => -180, :less_than_or_equal_to => 180}, allow_nil: true
  validates :status_code, numericality: { only_integer: true}
  validates :owner_phone_number, format: { with: ONLY_NUMBERS, message:"should only have numeric values." }, allow_nil: true
  validates :owner_sim_number, format: { with: ONLY_NUMBERS, message:"should only have numeric values." }, allow_nil: true

  after_save :find_loose_transactions

  def find_loose_transactions
    transactions << Transaction.where(location_id: location_id)
  end

  def self.type_of_hub(id)
    Transaction.find_by(location_id: id).transaction_code == 1 ? "Pump" : "Kiosk"
  end

  def self.get_new_hubs
    new_hubs_ids = Transaction.all.map{|transaction| transaction.location_id}.uniq - Hub.all.map{|hub| hub.location_id}.uniq
    new_hubs_ids.map{|location_id| {id: location_id, type: Hub.type_of_hub(location_id)}}
  end

  def associate_transactions
    Transaction.all.select{|tran| tran.location_id == self.location_id}.each {|tran| self.transactions << tran}
  end
end
