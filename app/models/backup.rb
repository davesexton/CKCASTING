module Backup

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def to_rb
      self.all.map do |m|
        "#{self.name}.create(\n" +
        m.attributes.map do |a|
          if a[1].class == Fixnum
            "  #{a[0]}: #{a[1]}"
          elsif a[1].class == String
            "  #{a[0]}: '#{a[1].gsub(/'/,"\\\\'")}'"
          else
            "  #{a[0]}: '#{a[1]}'"
          end
        end.join(",\n") + ")\n"
      end.join("\n")
    end

  end

end
