class GroupView
  include Crumble::ContextView

  getter group : Group

  def initialize(@ctx, @group); end

  ToHtml.instance_template do
    Crumble::Material::TopAppBar.new(
      leading_icon: nil,
      headline: group.name,
      trailing_icons: [] of Nil,
      type: :center_aligned
    )

    group.group_beverages_view
  end
end
