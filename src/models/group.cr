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
      alcoholic = false
      HTTP::Params.parse(body.gets_to_end) do |key, value|
        case key
        when "name"
          name = value
        when "alcoholic"
          alcoholic = (value == "1")
        end
      end

      if name
        beverage = Beverage.where({"name" => name}).first?

        unless beverage
          beverage = Beverage.create(name: name, alcoholic: alcoholic)
        end

        GroupBeverage.create(group_id: model.id, beverage_id: beverage.id)
      end
    end

    record Template, uri_path : String do
      css_class Field

      ToHtml.instance_template do
        form action: uri_path, method: "POST" do
          h3 { "Neues Getränk" }
          div Field do
            label { "Name:" }
            input type: :text, name: "name", required: true
          end
          div Field do
            label { "Alkoholisch" }
            input type: :checkbox, name: "alcoholic", value: "1"
          end
          button do
            "Speichern"
          end
        end
      end

      style do
        rule Field do
          display Flex
        end

        rule Field >> label do
          marginRight 5.px
        end
      end
    end

    def self.action_template(model)
      Template.new(uri_path(model.id))
    end
  end

  model_template :group_beverages_view do
    h3 { "Verfügbare Getränke" }
    div do
      group_beverages.each do |group_beverage|
        Crumble::Material::ListItem.to_html do
          group_beverage.beverage.name
        end
      end
    end
  end
end
