module Thot 
    class Varfiles
        
        extend Carioca::Injector if defined?(Carioca::Injector)
        attr_reader :data
        inject service: :output if self.respond_to? :inject
        
        def initialize(varfile: nil, environment: nil, dotfiles: ["./.thot.env","~/.thot.env"])
            @name = self.class
            @data = {}
            scanned_files = dotfiles
            scanned_files.push varfile unless varfile.nil?
            scanned_files.each do |file|
                real_file = File.expand_path(file)
                if File::exists? real_file then
                    output.info "Negociated files : #{real_file}, merging..." if self.respond_to?(:output)
                    datafile = IniFile.load(real_file)
                    @data.merge! datafile["global"]
                    @data.merge! datafile[environment] if datafile.sections.include? environment.to_s
                end
            end
            if self.respond_to?(:output) then
                if output.level == :debug then 
                    output.debug "merged data:"
                    @data.each  do |key,val|
                        output.debug "* #{key} = #{val}"
                    end
                end
            end
        end
    end
end