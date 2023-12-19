module Thot 
    class Tokenizer

        attr_reader :string
        attr_reader :tokens
        attr_reader :definitions 
    
        def initialize(string: )
            @string = string
            @definitions = {}
            @tokens = []
        end
    
        def detect
            if @string.valid_encoding?
                detected = @string.force_encoding("UTF-8").scan(/%%[^\%]*%%/).concat @string.force_encoding("UTF-8").scan(/\{\{[^\}]*\}\}/)
                detected.each  do |token|
                    key,*rest = token[2,(token.length - 4)].split('.')
                    filters = []; default = nil
                    if key =~ /(.*)\((.*)\)/ then
                        key = $1
                        default = $2
                    end
                    rest.each {|item|
                        if item =~ /(.*)\((.*)\)/ then 
                            filters.push $1  
                                default = $2 
        
                        else
                            filters.push item
                        end
                        }
                    @tokens.push key unless @tokens.include? key
                    @definitions[token] = {key: key, filters: filters , default: default }
                end
                @tokens.map!(&:downcase)
                @tokens.map!(&:to_sym)
            end
        end
    end
end