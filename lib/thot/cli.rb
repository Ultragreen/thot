


module Thot
  class CLI < Carioca::Container

    inject service: :output

    def initialize(options: , template_file: nil )

      @options = options
      output.level = (@options[:debug])? :debug : :info
      output.debug "Debugging mode activated" if @options[:debug]
      @template_file = template_file
      output.info "Assuming Environment : #{@options[:environment]}" if @options[:verbose]
      getting_data
      getting_content
    end


    def generate
      template =  Template::new(list_token: @data.keys, template_content: @content, strict: false)
      template.map @data
      output.info "Generating output" if @options[:verbose]
      puts template.output
    end

     private

     def getting_data
       if @options[:env_var_file] then
        output.info "Environment file given : #{@options[:env_var_file]}" if @options[:verbose]
       else
        output.info "Environment variables file argument missing, (--env-var-file) " if @options[:verbose]
       end
       @data =  Varfiles::new(environment: @options[:environment], varfile: @options[:env_var_file]).data
     end

     def getting_content
        @content = ""
       if @template_file.nil?
        output.info "Reading content from STDIN (CTRL+D to commit)" if STDIN.tty?
        output.info "Getting content from STDIN" if @options[:verbose] and not STDIN.tty?
         @content = ARGF.readlines.join
       else
        output.info "Reading content from file : #{@template_file}" if @options[:verbose]
        if File::exist? @template_file
         @content = File::readlines(@template_file).join
        else
         raise "file not found #{@template_file}"
        end
       end
     end

     def read_evt_file(file)
       return 
     end

  end
end
