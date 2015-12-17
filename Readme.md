# Synseer

Synseer (Syntax Seer) is a tool for helping students learn to parse Ruby syntax.
This is especially difficult for students who have never programmed before,
and it prevents them from being able to think about the higher ideas,
such as code structure, or what the code is doing.

The goal is not to understand everything they see,
it is purely to develop the mechanical ability of
looking at code and syntactically knowing what it is.
If you then want them to understand something like
the significance of a local variable vs an instance variable,
well, you'll have to teach them the object model
(which I also have a lot of material for).


## Video

A student goes through the pre-alpha version.

[https://vimeo.com/144960941](https://vimeo.com/144960941)

## Contributing

I really don't know what I'm doing with most of this technology,
so I'm figuring it out as I go. You'll need Ruby and Node.
How you get them is up to you.

After cloning, install dependencies with: `$ bundle install; npm install`

To start a server: `$ rake server`

After changing CSS or JavaScript, you need to rebuild: `$ rake build`
You don't need to restart the server unless you edit the Ruby files.
If you ever need to regenerate from scratch: `$ rake clobber; rake build`

The ruby you classify is in the "games" directory.
To add one or change the order, see the `default` method in `rb/synseer/app.rb`
After working on these, you need to restart a server.

To run tests `$ rake` Ruby code is tested in the `spec` directory,
JS unit tests are in the `test` directory, and integration tests are
done with phantom as part of the Ruby integration tests.

Assume most decisions are incidental, not intentional (I'm figuring it out as I go)

## Todo

* Add an about page
  ```
  English names
  Gradient of exercises
  That null suggestion
  Video of me going through it

  Intent
    Goal is not to learn these things
      recognize the structure of Ruby code
      expose you to Ruby code so it doesn't look alien
    game
      be fun
      your goal is to purely to get the time

    the keybindings are arbitrary
      the names are arbitrary

    How to do the exercises
  ```
* Better gradient of games
  * Start with each of the literal types
  * A game for each type
  * A game for each group of types
* Make sure each of the programs can be entered
* Update to new keybindings

## MOST COMMON SYNTAXES

Taken from Rails

```sh
$ find . -type f -name '*.rb' \
>  | ruby -ne 'print unless %r(/templates?/)' \
>  | ruby -rparser/ruby22 -ne '
     def count_asts(ast)
       return unless ast.kind_of? AST::Node
       puts ast.type
       ast.children.each { |c| count_asts c }
     end
     at_exit { $! && $stderr.puts("\e[31m#{$_}\e[0m") }
     count_asts Parser::Ruby22.parse(File.read($_.chomp));' \
>  | sort \
>  | uniq -c \
>  | sort -nr \
>  | head -20
164767 send
64931 str
54015 lvar
50302 const
46784 sym
36487 args
28016 begin
21721 pair
21444 int
20480 def
15724 lvasgn
15675 hash
15225 block
12438 ivar
12082 arg
7577 array
5243 if
3662 dstr
3631 class
3479 ivasgn
```

## MIT License

```
Copyright (c) 2015 Josh Cheek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
