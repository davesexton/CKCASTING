class Credit < ActiveRecord::Base
  belongs_to :Person

  def credit_item_text
    if credit_text =~ /^\*/
      credit_text[1..-1]
    else
      credit_text
    end
  end

end
