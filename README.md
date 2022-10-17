# Thot

Thot is THe Operative Templating : the simpliest solution for Ruby and command to templatize

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'thot'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install thot


## Principe

Thot is a simple templating tool, with :
- a template including token, like : %%TOKEN_NAME%% => Token MUST be in uppercase
- a hash of data (symbols as keys) corresponding, like : <pre>{token_name: 'value'}</pre>  
It could generate an output.

### Usecase

- with data :  <pre>{name: 'Romain'}</pre>
- and template content : "Hello %%NAME%% !"

Thot simply generate :
   'Hello Romain !'

### Advanced usecase 

- with data :  <pre>{firstname: 'romain', name: 'georges', nickname: 'zaidyur'}</pre>
- and template content : "Hello %%FIRSTNAME.capitalize%% %%NAME.upcase%%  your nickname is : %%NICKNAME.reverse.capitalize%% !"

Thot generate :
   "Hello Romain GEORGES your nickname is : Ruydiaz !"


Thot actually supports String to String piped filters :
- filters must be stacked seperated by '.'
- filters must be in lowercase
- filters must be String instance methods returning a String (Modifier)

Note : Your could monkey patch String or use Refinment for implementing our own filters.  


## Usage

Thot is already a library for you usage and a CLI. 

###  Ruby Library usage

you could use Thot in your Ruby code :

#### Strict mode and accessor input

Note : Considering 'template.txt' with : 'Hello %%NAME !!'
Note : in strict mode if the Tokens in template file don't match exactly the given token list, Thot raise an exception.  

```ruby
   require 'thot'
   include Thot
   template = Template::new list_token: [:name] , template_file: './template.txt'
   template.name = 'Romain'
   puts template.output
````

return

   Hello Romain !!


#### Strict mode false with accesor input and template_content

```ruby
   require 'thot'
   include Thot
   template = Template::new list_token: [:name, :surname] , template_content: 'Hello %%NAME !!'
   template.name = 'Romain'
   puts template.output
````

return

    Hello Romain !!

#### Strict mode false with map input and template_content

```ruby
   require 'thot'
   include Thot
   template = Template::new list_token: [:name, :surname] , template_content: 'Hello %%NAME !!'
   template.map {name: 'Romain', surname: 'Georges' }
   puts template.output
````

return

   Hello Romain !!



###   CLI usage

Thot come with a CLI for templating :
- reading from STDIN or list files arguments
- getting values from variables file by argument [MANDATORY]  --env-var-file FILENAME
- display output on STDOUT
- verbose mode on STDERR if -v options.

Note : CLI work only strict mode false, you could have unused keys in datas. 

#### Pre-requisites

* a file 'template.txt' with : "Hello %%NAME%% !!"
* a variables file with lines, like :
```
    key=value
    key = value
      key = value
    # comments and other lines are ignored
```

sample, env.test: 

```
    name=Romain
```

In the same path

#### STDIN from echo

```
    $ echo "Hello %%NAME%% !!" |thot -e env.test
```

#### STDIN from input

```
    $ thot -e env.test < template.txt
```

#### Files list 

```
    $ thot -e env.test template1.txt template2.txt
```

#### Typical usage

```
    $ thot -e env.test < template.txt > output.txt
```

###


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Ultragreen/thot.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
