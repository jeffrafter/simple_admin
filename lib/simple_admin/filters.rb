module SimpleAdmin
  class Filters < Attributes
    alias_method :filter, :attribute
  end
end
