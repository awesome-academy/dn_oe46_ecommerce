class Category < ApplicationRecord
  has_ancestry
  has_many :products, dependent: :destroy
  validates :name, presence: true,
                   length: {maximum: Settings.validate.normal_length}
end
