module Spree::RecurringOrders
  class DeliveryTime
    include Comparable

    attr_reader :description
    attr_reader :description_from
    attr_reader :description_to

    def initialize(args) 
      @description = args[:description].to_s
      parse_description

      @morning_cutoff_time = Time.zone.parse(args[:cutoff_time])
    end

    def description=(value)
      @description = value
      parse_description
    end

    def from
      Time.zone.parse(@description_from) if valid?
    end

    def to
      Time.zone.parse(@description_to) if valid?
    end

    def to_s
      @description
    end

    def <=>(compare_to_time)
      from <=> compare_to_time if valid?
    end

    def valid?
      regex = /(\d{1,}\:*\d*(am|pm){1}\sto\s\d{1,}\:*\d*(am|pm){1})/i
      self.description and !!regex.match(self.description)
    end

    def afternoon?
      to > @morning_cutoff_time
    end

    def morning?
      to < @morning_cutoff_time
    end

    private

    def parse_description
      if valid?
        @description_from = @description.split('to')[0].strip!
        @description_to = @description.split('to')[1].strip!
      end
    end
  end
end
