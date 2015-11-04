require 'syntax_spray/app'

require 'capybara/rspec'
require 'capybara/poltergeist'
Capybara.app            = SyntaxSpray::App.default
Capybara.default_driver = :poltergeist

RSpec.describe SyntaxSpray::App, type: :feature do
  example 'new user plays their first game' do
    # When I go to the root page, it shows me a listing of syntax games and scores
    page.visit '/'
    game_elements = page.all '.available_games'
    expect(game_elements).to_not be_empty

    # Since I am new, all games are scored as unattempted
    game_elements.each do |game_element|
      expect(game_element.find('.score').text).to eq 'unattempted'
    end

    # I have completed 0 games, and have a total time of 0 seconds, 0 correct, and 0 incorrect
    expect(page.find '.total_score .games_completed').to have_text '0'
    expect(page.find '.total_score .correct'        ).to have_text '0'
    expect(page.find '.total_score .incorrect'      ).to have_text '0'
    expect(page.find '.total_score .time'           ).to have_text '0 seconds'

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
