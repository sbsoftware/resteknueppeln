class GroupView
  include Crumble::ContextView

  getter group : Group

  def initialize(@ctx, @group); end

  record ShareLink, group : Group do
    stimulus_controller ShareController do
      values url: String

      action :share do |event|
        event.preventDefault._call

        if navigator.share
          navigator.share({text: this.urlValue})
        else
          window.alert("Teilen auf diesem Gerät leider nicht möglich!")
        end
      end
    end

    ToHtml.instance_template do
      div ShareController, ShareController.share_action("click"), ShareController.url_value("https://resteknueppeln.party#{AccessResource.uri_path(group.access_token.value)}")do
        Crumble::Material::Icon.new("share")
      end
    end
  end

  css_class Recipes
  css_class BeverageFormContainer

  ToHtml.instance_template do
    Crumble::Material::TopAppBar.new(
      leading_icon: nil,
      headline: group.name,
      trailing_icons: [ShareLink.new(group)],
      type: :center_aligned
    )

    div Recipes do
      group.create_recipe_action_template
      group.recipes_view
    end
    hr
    div BeverageFormContainer do
      group.create_group_beverage_action_template
    end
    hr
    group.group_beverages_view
  end

  style do
    rule Recipes, BeverageFormContainer do
      padding 16.px
    end
  end
end
