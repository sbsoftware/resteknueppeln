class Orma::Record
  macro inherited
    {% unless @type.abstract? %}
      {{@type}}.continuous_migration!
    {% end %}
  end
end

# HACK: Add ordering
class Orma::Query
  getter order_clause : String?

  def order_by_id!(direction = "ASC")
    @order_clause = " ORDER BY id #{direction}"

    self
  end
end
