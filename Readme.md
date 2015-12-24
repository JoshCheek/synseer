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

* Thoughts /w Justin `^_^`
  * "Incorrect" dissuades guessing, which I want to encourge, b/c it's the most effective form of feedback that the app acn provide.
    What if we rename "Inforrect" to "tries".
  * Auto-"try" you at some number of seconds.
    1. This creates a "sense of urgency" (Air Force lingo ;) which gets them thinking and moving quicker.
    2. This removes the viability of the "sit and think for 10 min" strategy
    3. This removes long periods of confusion. ie we assume any option you can't answer in 5s is past the "zone of proximal development"
       then this takes you out of that zone, aka scaffolding.
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

## Thoughts

Notes on how to use games to teach.

```
https://www.youtube.com/watch?v=n_xG1Yg_QoM
  Leveling:
    restrict info the user has to know to make progress
  Bonuses for using advanced techniques
    Maybe on Synseer, allow them to create custom keybindings and keybinding groups (ie 3s for sss -- which implies a macro system 3(combo))
  Maybe something where they enter their own syntax and their score depends on various things like
    How many different kinds of syntax they use
    How few characters they can use

https://www.youtube.com/watch?v=ea6UuRTjkKs
  "Don't ignore difficulty curve. Just because a game is difficult doesn't mean that its difficulty can just fluctuate all over the place,
  have huge spikes, or be unreasonably difficult up front."

  "You don't want to simply set something before them that cuases them to walk away because they hit challenge which was too tough too early
  that's just punishing. It is very easy to make a punishing game. It is quite challenging, though, to get your player through a difficult one."

https://www.youtube.com/watch?v=QxfkWZPAUg4
  "When looked at objectively, this is actually pretty awesome, but I'm not sure it always feels awesome"
  "Getting that little icon that I can drag directly on my character right away feels like progress, it's much more tangible and immediate, much more direct"
  "The item drops *feel* more substantial"
  "[Perhaps] allowing you to select what items you want to work towards, and putting a bar in the top right corner that filled whenever you got minerals. So whenever you picked up something your progress was clear"
  Maybe some mechanic to give it the feel of progress?

https://www.youtube.com/watch?v=tWtvrPTbQ_c&index=18&list=PLB9B0CA00461BB187
  Things that make games fun w/o being abusive:
  1. Mystery
  2. Mastery
  3. Mental Challenge
  4. Narrative
  5. Novelty
  6. Flow

  Synseer should prefer #6 and then #2

https://www.youtube.com/watch?v=BCPcn-Q5nKE&list=PLB9B0CA00461BB187&index=34
  Tutorials 101
  * Less text (kills pacing, destroys immersion, often skipped)
  * Don't frontload all the knowledge
  * Introduce the UI they need as it is necessary
    * Maybe keybindings you haven't needed yet are grayed out so you know they don't matter
  * Watch your players try to use it, b/c there's shit that's obvious to you that no one else will get
  * Be mindful of your demographic (eg I want non-programmers)
  * Tutorials should be skippable
  * The info should be available at all times (eg how-to videos)

https://www.youtube.com/watch?v=rlQrTHrwyxQ&index=35&list=PLB9B0CA00461BB187
  Tangential Learning
  "This is what tangential learning is all about, it's the idea that some portion of your audience will self-educate if you
  can introduce them to topics in a context they already find exciting and engaging"

https://www.youtube.com/watch?v=TlBR1z-ue-I&list=PLB9B0CA00461BB187&index=133
  Difference in scale (more enemies, more syntax challenges) vs difference in kind (parts of the game that feel different, eg time in town vs time in dungeon -- maybe keymap editor?)

https://www.youtube.com/watch?v=6Q7ECX5FaX0&index=156&list=PLB9B0CA00461BB187
  The feeling of agency -- what makes choice meaningful?
  "A choice is any moment during play that the player could perform 2 or more distinct actions, but has to pick some number of actions less than the total number available to execute"
  "A choice is meaningful when the decision making process isn't arbitrary, when the player understands the choice they're making and has some system to weigh their options.
  This doesn't mean that they have to fully understand what the consequences of each decision will be, only that they believe they have what they need to weigh the options presented to them."
```


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
