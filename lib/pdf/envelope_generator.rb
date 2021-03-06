require 'prawn'
require 'prawn/measurement_extensions'

module PDF
  class EnvelopeGenerator
    def self.generate(order)
      pdf = Prawn::Document.new :margin => 0, :page_size => [9.2.cm, 16.5.cm], :page_layout => :landscape
      pdf.font_families.update 'Cabin' => { :normal => "#{ Rails.root.to_s }/lib/assets/Cabin-Bold.ttf" }

      pdf.font "Cabin", :size => 16

      pdf.image "#{ Rails.root.to_s }/lib/assets/logo.2.png", :at => [0, 3.6.in], :width => 1.in
      pdf.bounding_box [1.2.in, 3.55.in], :width => 3.5.in, :height => 2.in do
        pdf.fill_color "1D4088"
        pdf.text 'conne.cc'
        pdf.font "Cabin", :size => 12
        pdf.fill_color "000000"
        pdf.text '211 112th Ave NE #312'
        pdf.text 'Bellevue, WA 98004'
        pdf.fill_color "1D4088"
      end

      pdf.bounding_box [2.2.in, 2.in], :width => 3.5.in, :height => 2.in do
        pdf.font "Cabin", :size => 18
        pdf.text order.user.name
        pdf.font "Cabin", :size => 14
        pdf.fill_color "000000"
        pdf.text order.address1
        if order.address2
          pdf.text order.address2
        end
        pdf.text "#{ order.city }, #{ order.region } #{ order.postal_code }"
      end
      return pdf
    end

  end
end

