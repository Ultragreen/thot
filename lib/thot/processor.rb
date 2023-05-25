module Thot
    class Processor
        attr_reader :value
        attr_reader :rule

        def initialize(value: , rule:)
            @value = value
            @rule  = rule
        end

        def result
            if @value.nil? then
                result = (@rule[:default])? @rule[:default] : ''
            else
                result = @value
                @rule[:filters].each do |filter|
                    result = result.send filter.to_sym if result.respond_to? filter.to_sym
                end
            end
            return result
        end

    end
end