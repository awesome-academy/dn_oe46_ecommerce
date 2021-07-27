class Category < ApplicationRecord
  has_many :childrens, class_name: Category.name,
                       foreign_key: :parent_id,
                       dependent: :destroy
  belongs_to :parent, class_name: Category.name, optional: true
  has_many :products, dependent: :destroy
  validates :name, presence: true,
                   length: {maximum: Settings.validate.normal_length}
  scope :parents, ->{where parent_id: nil}
end
