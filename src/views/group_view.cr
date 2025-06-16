class GroupView
  include Crumble::ContextView

  getter group : Group

  def initialize(@ctx, @group); end

  css_class Recipes
  css_class BeverageFormContainer

  ToHtml.instance_template do
    Crumble::Material::TopAppBar.new(
      leading_icon: nil,
      headline: group.name,
      trailing_icons: [] of Nil,
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
