class ApplicationStyle < CSS::Stylesheet
  rules do
    rule body, button, input do
      fontFamily "Roboto"
    end

    rule a do
      color Black
      textDecoration None
    end

    rule "[data-action]:not(input)" do
      prop("cursor", "pointer")
    end

    rule "input[type=\"text\"]", "input[type=\"number\"]" do
      prop("border", "none")
      prop("border-bottom", "1px solid black")
      backgroundColor "#EEE"
      padding 8.px
      prop("box-sizing", "border-box")
    end

    rule button do
      prop("border", "none")
      prop("outset", "none")
      backgroundColor "transparent"
    end

    rule Crumble::Material::Card::Card do
      height "auto"
      minHeight 100.px
      marginBottom 16.px
    end
  end
end
