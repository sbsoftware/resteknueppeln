class GroupBeverage < ApplicationRecord
  column group_id : Int64
  column beverage_id : Int64

  def group
    Group.find(group_id)
  end

  def beverage
    Beverage.find(beverage_id)
  end

  delete_record_action :remove, group.group_beverages_view do
    def self.confirm_prompt(model)
      "#{model.beverage.name} wirklich löschen?"
    end
  end
end
