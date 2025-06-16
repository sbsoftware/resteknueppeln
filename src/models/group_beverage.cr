class GroupBeverage < ApplicationRecord
  column group_id : Int64
  column beverage_id : Int64

  def beverage
    Beverage.find(beverage_id)
  end
end
