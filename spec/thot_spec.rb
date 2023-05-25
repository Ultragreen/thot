RSpec.describe Thot do
  it "has a version number" do
    expect(Thot::VERSION).not_to be nil
  end
end

include Thot

RSpec.describe Template do
  $template_file = "/tmp/template.txt"
  $nonexistantfile = "/tmp/nonexistant.txt"
  $template = "Hello %%NAME%% %%NAME.upcase%% %%NAME.reverse.downcase%% !!"
  $result = "Hello Romain ROMAIN niamor !!"
  $goodtoken = :name
  $badtoken = :surname
  $value = 'Romain'
  before :all do
    `echo "#{$template}" > #{$template_file}`
    File::unlink($nonexistantfile) if File::exist?($nonexistantfile)
  end
  subject { Template }
  specify { should be_an_instance_of Class }
  context "Exception case" do
    it "should raise NoTemplateFile if no file or content given" do
      expect { Template::new(list_token: [$goodtoken] ) }.to raise_error NoTemplateFile
    end
    it "should raise NotAToken if try to send ##{$badtoken} and '#{$badtoken}' not a valid token" do
      expect { Template::new(list_token: [$goodtoken], template_file: $template_file).send($badtoken.to_sym)}.to raise_error NotAToken
    end
    it "should raise InvalidTokenList if initialized with ['#{$goodtoken}','#{$badtoken}'] tokens list" do
      expect { Template::new(list_token: [$goodtoken,$badtoken] , template_file: $template_file)}.to raise_error InvalidTokenList
    end
    it "should not raise InvalidTokenList if initialized with ['#{$goodtoken}','#{$badtoken}'] tokens list and strict: false" do
      expect { Template::new(strict: false, list_token: [$goodtoken,$badtoken] , template_file: $template_file)}.not_to raise_error InvalidTokenList
    end
        it "should not raise if initialized with template_content and a valid list_token for respective strict mode" do
      expect { Template::new(strict: false, list_token: [$goodtoken,$badtoken] , template_content: $template)}.not_to raise_error NoTemplateFile
    end
    it "should raise NoTemplateFile if template file not exist AND initialized with ['#{$goodtoken}','#{$badtoken}'] tokens list" do
      expect { Template::new(list_token: [$goodtoken,$badtoken] , template_file: $nonexistantfile)}.to raise_error NoTemplateFile
    end
  end

  context "Template <execution> with token '#{$goodtoken}', content = '#{$content}', and ##{$goodtoken}='#{$value}'" do
    before :all do
      $test = Template::new(list_token: [$goodtoken] , template_file: $template_file)
    end
    context "#content" do
      specify {expect($test.content).to be_an_instance_of String }
      it "should have '#{$template}' in #content" do
        expect( $test.content).to eq($template)
      end
      specify {expect($test).to_not respond_to 'content=' }
    end
    context "#token_list" do
      specify {expect($test.list_token).to be_an_instance_of Array }
      it "should have ['#{$goodtoken}'] in #list_token" do
        expect($test.list_token).to eq([$goodtoken])
      end
      specify { expect($test).to_not respond_to 'token_list=' }
    end
    context "virtual (methode_missing) #{$goodtoken}" do
      specify { expect($test.send($goodtoken.to_sym)).to be_an_instance_of String }
      specify { expect($test).to respond_to($goodtoken.to_sym) }
      specify { $test.send("#{$goodtoken}=".to_sym,$value); expect($test.send($goodtoken)).to eq($value) }
      it "should raise ArgumentError if virtual methode '##{$goodtoken}=' got non String argument (accessor)" do
        expect { $test.send("#{$goodtoken}=".to_sym, 1) }.to raise_error ArgumentError
      end
    end
    context "#output" do
      it "should #output #{$result}' if set ##{$goodtoken} = '#{$value}' and msg send #output" do
        $test.name = $value
        expect( $test.output).to eq($result)
      end
      specify { expect($test).to_not respond_to 'output=' }
    end
  end
  context "Template <execution> with token '#{$goodtoken}' and '#{$badtoken}', content = '#{$content}', and ##{$badtoken} usage with strict = false" do
    before :all do
      $test = Template::new(list_token: [$goodtoken,$badtoken] , template_file: $template_file, strict: false)
    end
    specify { expect($test).to respond_to $badtoken.to_sym }
    specify { expect($test).to respond_to $goodtoken.to_sym }
    specify { $test.send("#{$goodtoken}=".to_sym,$value); expect($test.send($goodtoken)).to eq($value) }
    specify { $test.send("#{$badtoken}=".to_sym,$value); expect($test.send($badtoken)).to eq($value) }
    specify { expect( $test.output).to eq($result) }
    
  end
    
  after :all do
    File::unlink($template_file) if File::exist?($template_file)
    $test = nil
  end
end


RSpec.describe Varfiles do
  before :all do
    $varfile  = "./samples/.env.prod"
    $dotfile = "./samples/.thot.env" 
    $result = {:name=>"romain", :surname=>"georges", :var1=>"local", :var2 =>"global"}
  end
  context "Structure" do
    subject { Varfiles }
    specify { should be_an_instance_of Class }
  end
  context "Runtime" do 
    subject { Varfiles::new(varfile: $varfile, environment: :development, dotfiles: [$dotfile]) }
    context "#data" do
      specify {expect(subject.data).to be_an_instance_of Hash }
      it "should respond with good content" do
        expect( subject.data).to eq($result )
      end
    end
  end
end