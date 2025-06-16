require "./ingredient"

class Recipe < ApplicationRecord
  column name : String
  column group_id : Int64

  has_many_of Ingredient
end
