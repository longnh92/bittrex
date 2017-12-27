module Util
  module Format
    def sat_format(value)
      return if value.nil?
      '%.8f' % value
    end
  end
end
