module Backup

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def to_rb
      self.order('id').all.map do |m|
        "#-------------------------\n" +
        "#{self.name.downcase} = #{self.name}.new(\n" +
        m.attributes.except('id', 'created_at', 'updated_at').map do |a|
          if a[1].nil?
            "  #{a[0]}: nil"
          elsif a[1].class == Fixnum || a[1].class == Float
            "  #{a[0]}: #{a[1]}"
          elsif a[1].class == String
            "  #{a[0]}: '#{a[1].gsub(/'/,"\\\\'")}'"
          else
            "  #{a[0]}: '#{a[1]}'"
          end
        end.join(",\n") + ")\n" +
        "#{self.name.downcase}.id = #{m.id}\n" +
        "#{self.name.downcase}.save(validate: false)"
      end.join("\n") + "\nputs '#{self.name} records created'\n"
    end

  end

end
