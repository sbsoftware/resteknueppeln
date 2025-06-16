require "./group_beverage"
require "./recipe"

class Group < ApplicationRecord
  column name : String

  has_many_of GroupBeverage
  has_many_of Recipe

  model_action :create_recipe, recipes_view do
    controller do
      RecipeService.create_recipe(model)
    end

    record Template, uri_path : String do
      css_class ButtonRow

      ToHtml.instance_template do
        form action: uri_path, method: "POST" do
          div ButtonRow do
            button do
              "Neues Rezept generieren"
            end
          end
        end
      end

      style do
        rule ButtonRow do
          display Flex
          justifyContent Center
        end

        rule ButtonRow >> button do
          border 1.px, Solid, Black
          padding 5.px
        end
      end
    end

    def self.action_template(model)
      Template.new(uri_path(model.id))
    end
  end

  model_template :recipes_view do
    h3 { "Rezepte" }
    div do
      recipes.each do |recipe|
        Crumble::Material::Card.new.to_html do
          Crumble::Material::Card::Title.new(recipe.name).to_html
          Crumble::Material::Card::SecondaryText.new.to_html do
            recipe.ingredients.map do |ingredient|
              "#{ingredient.amount_cl}cl #{ingredient.beverage.name}"
            end.join(", ")
          end
        end
      end
    end
  end

  model_action :create_group_beverage, group_beverages_view do
    controller do
      unless body = ctx.request.body
        ctx.response.status = :bad_request
        return
      end

      name = nil
      alcoholic = false
      body_str = body.gets_to_end
      HTTP::Params.parse(body_str) do |key, value|
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
      css_class ButtonRow

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
          div ButtonRow do
            button do
              "Speichern"
            end
          end
        end
      end

      style do
        rule Field do
          display Flex
          alignItems Center
          marginBottom 16.px
        end

        rule Field >> label do
          marginRight 5.px
        end

        rule ButtonRow do
          display Flex
          justifyContent FlexEnd
        end
      end
    end

    def self.action_template(model)
      Template.new(uri_path(model.id))
    end
  end

  css_class BeveragesHeading

  model_template :group_beverages_view do
    div BeveragesHeading do
      h3 { "Verfügbare Getränke" }
    end
    div do
      group_beverages.each do |group_beverage|
        Crumble::Material::ListItem.to_html do
          group_beverage.beverage.name
          if group_beverage.beverage.alcoholic.value
            " (alkoholisch)"
          end
        end
      end
    end
  end

  style do
    rule BeveragesHeading do
      padding 0, 16.px
    end
  end
end
