module Backup

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods

    def to_rb
      self.order(:id).all.map do |m|
        "#-------------------------\n#{self.name}.create(\n" +
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
        end.join(",\n") + ").update_column(:id, #{m.id})\n"
      end.join("\n") + "\n"
    end

  end

end
