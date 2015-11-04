require 'syntax_spray/app'

RSpec.describe SyntaxSpray::App do
  describe 'new user plays their first game' do
    # When I go to the root page, it shows me a listing of syntax games and scores
    # Since I am new, all games are scored as unattempted
    # I have completed 0 games, and have a total time of 0 seconds
    # When I click on the "integer addition" example, it takes me to "/integer_addition"
    # There is a code display containing the text "1 + 2"

    # After 1 second, my time has increased from 0 to 1

    # I see that it is waiting for me to classify the "1 + 2" expression
    # I press "s" for "send", and my "correct" count increases from 0 to 1

    # I see that it is waiting for me to classify the "1" expression
    # I press "s" for "send", and my "correct" count stays at 1 while my "incorrect" count increases from 0 to 1
    # I press "i" for "integer", and my "correct" count increases from 1 to 2

    # I see that it is waiting for me to classify the "2" expression
    # I press "s" for "send", and my "correct" count stays at 1 while my "incorrect" count increases from 0 to 1
    # I press "i" for "integer", and my "correct" count increases from 2 to 3

    # I see that I have completed the challenge
    # After 1 second, my time has not increased
    # I press "return" and it takes me back to the root page

    # Now I see that all games are scored as unattempted, except "integer addition"
    # I have completed 1 game, and have a total of 1 seconds, 3 correct, and 1 incorrect
  end
end
