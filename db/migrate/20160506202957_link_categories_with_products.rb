class LinkCategoriesWithProducts < ActiveRecord::Migration
  create_table :categories_products, id: false do |t|
    t.belongs_to :category, index: true
    t.belongs_to :product, index: true
  end
end
