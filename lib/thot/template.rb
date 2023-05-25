# Thot base module
module Thot
    class Error < StandardError; end
    
    
    # KISS template Engine
    class Template
      
      # getter of the list of token
      attr_reader :list_token
      # getter of the template file
      attr_reader :template_file
      # getter of the flat content of the template
      attr_reader :content

  
   
      
      # constructor : generate the pseudo accessor for template Class from token list
      def initialize(template_file: nil, list_token: , strict: true, template_content: nil)
        @myput  = Carioca::Registry::init.get_service name: :output if defined?(Carioca::Injector)
        @result = ""
        if template_file
          @template_file = template_file
          raise NoTemplateFile::new('No template file found') unless File::exist?(@template_file)
          begin
            @content = IO::readlines(@template_file).join.chomp
          rescue
            raise NoTemplateFile::new('Template file read error')
          end
        elsif template_content
          @content =  template_content
        else
          raise NoTemplateFile::new('No template file found or template content')
        end
          
        @tokenizer = Tokenizer::new string: @content ; @tokenizer.detect
        token_from_template = @tokenizer.tokens
       

       
        begin
          @list_token = list_token
          @hash_token = Hash::new; @list_token.each{|_item| @hash_token[_item.to_s] = String::new('')}
        rescue
          raise InvalidTokenList::new("Token list malformation")
        end
        if strict
          raise InvalidTokenList::new("Token list doesn't match the template") unless token_from_template.sort == @list_token.sort
        end
        if @myput then
          if @myput.level == :debug then 
            @myput.debug "Template :"
              @content.split("\n").each  do |line|
                @myput.debug "  #{line}"
              end
          end
        end
        @list_token.each do |_token|
          self.instance_eval do
            define_singleton_method(:"#{_token}=") {|_value| raise ArgumentError::new('Not a String') unless _value.class == String; @hash_token[__callee__.to_s.chomp('=')] = _value }
            define_singleton_method(_token.to_sym) { return @hash_token[__callee__.to_s]  }
          end
        end
        
      end
      
      # generic accessor
      # @param [Symbol] _token in the token list
      # @param [String] _value a text value
      # @raise [ArgumentError] if _valu is not a String
      def token(_token,_value)
        raise ArgumentError::new('Not a String') unless _value.class == String
        @hash_token[_token.to_s] = _value
      end
      
      # map a hash against templates token_list
      # @param [Hash] _hash a hash data to map
      def map(_hash)
        _data = {}
        _hash.each { |item,val|
          raise ArgumentError::new("#{item} : Not a String") unless val.class == String
          _data[item.to_s.downcase] = val
        }
        @hash_token = _data
      end
      
      # collector for pseudo accessor to prevent bad mapping
      # @raise [NotAToken] if caling an accessor not mapped in token list
      def method_missing(_name,*_args)
        raise NotAToken
      end
      
      # the templater himself : proceed to templating
      # @return [String] the template output
      def output
        @result = @content

        @tokenizer.definitions.each do |item, rule|
          @result.gsub!(item, Thot::Processor::new(value:  @hash_token[rule[:key].downcase], rule: rule).result)
        end

        if @myput then
          if @myput.level == :debug then 
            @myput.debug "Output :"
              @result.split("\n").each  do |line|
                @myput.debug "  #{line}"
              end
          end
        end
        return @result
      end
      
    end
    
    # Exception for an invalid Token list
    class InvalidTokenList < Exception; end
      # Exception for an malformed token
    class NotAToken < Exception; end
    # Exception for an invalid template file
    class NoTemplateFile < Exception; end
    
  end
  
  
      
  