class HomeView
  ToHtml.class_template do
    Crumble::Material::TopAppBar.new(
      leading_icon: nil,
      headline: "RESTEKNÜPPELN",
      trailing_icons: [] of Nil,
      type: :center_aligned
    )

    form action: GroupsResource.uri_path, method: "POST" do
      label { "Name" }
      input type: :text, name: "name"
      button do
        "Neue Gruppe"
      end
    end
  end
end
