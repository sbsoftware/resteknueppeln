class Ingredient < ApplicationRecord
  column recipe_id : Int64
  column beverage_id : Int64
  column amount_cl : Int64

  def beverage
    Beverage.find(beverage_id)
  end
end
