macro style(&blk)
  class Style < CSS::Stylesheet
    rules {{blk}}
  end

  class ::ToHtml::Layout
    append_to_head {{@type}}::Style
  end
end
