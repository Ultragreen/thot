module Thot
  class CLI

    def initialize(options: , list_templates_file: nil )
      @list_templates_file = list_templates_file
      @options = options
      getting_data
      getting_content
    end


    def generate
      template =  Template::new(list_token: @data.keys, template_content: @content, strict: false)
      template.map @data
      STDERR.puts "Generating output" if @options[:verbose]
      puts template.output
    end

     private

     def getting_data
       if @options[:env_var_file] then
         STDERR.puts "Environment file given : #{@options[:env_var_file]}" if @options[:verbose]
         @data = read_evt_file(@options[:env_var_file])
       else
         raise "Environment variables file argument missing, (--env-var-file) "
       end
     end

     def getting_content
       if @list_templates_file.empty?
         STDERR.puts "Reading content from STDIN" if @options[:verbose]
         @content = ARGF.readlines.join
       else
         STDERR.puts "Reading content from file(s) : #{@list_templates_file}" if @options[:verbose]
         @list_templates_file.each do |item|
           if File::exist? item
             @content.concat(File::readlines(item)).join
           else
             raise "file not found #{item}"
           end
         end
       end
     end

     def read_evt_file(file)
       res = {}
       if File::exist? file
         content =  File::readlines(file)
       else
         raise "Environment variables file not found #{file}"
       end
       content.each do |line|
         next if line =~ /#/
         key,value = line.split('=')
         res[key.strip.to_sym] = value.strip if value
       end
       return res
     end

  end
end
