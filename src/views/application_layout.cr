class ApplicationLayout < Crumble::Material::Layout
  append_to_head ApplicationStyle

  def top_app_bar
    nil
  end
end
