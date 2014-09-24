class Transaction < ActiveRecord::Base
  belongs_to :transactable, polymorphic:true
  validates_uniqueness_of :transaction_code, scope: [:location_id, :transaction_time]
  scope :credits_sold, -> { where(transaction_code: [20,21]) }

end
