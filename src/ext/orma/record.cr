class Orma::Record
  macro inherited
    {% unless @type.abstract? %}
      {{@type}}.continuous_migration!
    {% end %}
  end
end
