module Backup

  def self.included base
    base.extend ClassMethods
  end

  module ClassMethods
    def seed_output

      s = ''
      last = self.attribute_names.last
      self.all.to_yaml.each_line do |line|

        line.gsub!(/^---$/, '')
        line.gsub!(/"/, '\"')
        line.gsub!("attributes:\n", '')

        line.gsub!(/- !ruby\/object:(\w+)/, "#{self.name}.create(")
        line.gsub!(/: (.*)/, ': "\1",')
        line.gsub!(/: ("(\d*)")/, ': \2')
        line.gsub!(/: ,/, ': ""',)
        if line =~ /#{last}/
          line.reverse!.sub!(',', ')').reverse!
        end
        #line.gsub!(/('[^']*)(')([^']*')/, '\1\\\\\2\3')
        s += line
      end
      s
    end
  end

end
