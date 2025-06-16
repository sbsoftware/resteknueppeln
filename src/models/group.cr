require "./group_beverage"

class Group < ApplicationRecord
  column name : String

  has_many_of GroupBeverage

  model_action :create_group_beverage, group_beverages_view do
    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      name = nil
      alcoholic = nil
      HTTP::Params.parse(body.gets_to_end) do |key, value|
        case key
        when "name"
          name = value
        when "alcoholic"
          alcoholic = (value == "1")
        end
      end

      if name && alcoholic
        beverage = Beverage.where({"name" => name}).first?

        unless beverage
          beverage = Beverage.create(name: name, alcoholic: alcoholic)
        end

        GroupBeverage.create(group_id: model.id, beverage_id: beverage.id)
      end
    end
  end

  model_template :group_beverages_view do
    div do
      group_beverages.each do |group_beverage|
        Crumble::Material::ListItem.to_html do
          group_beverage.beverage.name
        end
      end
    end
  end
end
