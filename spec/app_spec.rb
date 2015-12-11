require 'synseer/app'

RSpec.describe Synseer::App, integration: true, type: :feature do
  before :all do
    require 'capybara/rspec'
    require 'capybara/poltergeist'
    Capybara.app            = Synseer::App.default
    Capybara.default_driver = :poltergeist
  end

  def guess(type, browser)
    # currently, these are just enough to make them unique, so they will be accepted
    case type
    when :method
      browser.send_keys("s")
      browser.send_keys("e")
      browser.send_keys("n")
    when :integer
      browser.send_keys('i')
      browser.send_keys('n')
    else raise "WHAT TYPE IS THIS: #{method.inspect}"
    end
  end

  example 'new user plays their first game' do
    # When I go to the root page, it shows me a listing of syntax games and scores
    page.visit '/'
    scores = page.all '.available_games .score'
    expect(scores).to_not be_empty

    # Since I am new, all games are scored as unattempted
    scores.each do |game_element|
      expect(game_element.text.downcase).to include 'unattempted'
    end

    # I have completed 0 games, and have a total time of 0 seconds, 0 correct, and 0 incorrect
    expect(page.find '.total_score .games_completed').to have_text '0'
    expect(page.find '.total_score .correct'        ).to have_text '0'
    expect(page.find '.total_score .incorrect'      ).to have_text '0'
    expect(page.find '.total_score .time'           ).to have_text '0:00'

    # When I click on the "integer addition" example, it takes me to "/games/integer_addition"
    page.click_link 'integer addition'
    expect(page.current_path).to eq '/games/integer_addition'

    # There is a code display containing the text "1 + 2"
    line1 = page.all('.CodeMirror-line:first-of-type').first
    expect(line1.text).to eq '1 + 2'

    # After 1 second, my time has increased from 0 to 1
    time = page.find('.stats .time')
    expect(time.text).to eq '0:00'
    sleep 1
    expect(time.text).to eq '0:01'

    # I see that it is waiting for me to classify the "1 + 2" expression
    current_element = page.all('.currentElement').map(&:text).join.delete(" ")
    expect(current_element).to eq '1+2'

    # I press "m" for "send" (method), and my "correct" count increases from 0 to 1
    browser = page.find('html').native
    correct = page.find '.stats .correct'
    expect(correct.text).to eq '0'
    guess :method, browser
    expect(correct.text).to eq '1'

    # I see that it is waiting for me to classify the "1" expression
    current_element = page.all('.currentElement').map(&:text).join.delete(" ")
    expect(current_element).to eq '1'

    # I press "m" for "send" (method), and my "correct" count stays at 1 while my "incorrect" count increases from 0 to 1
    incorrect = page.find '.stats .incorrect'
    expect(correct.text).to eq '1'
    expect(incorrect.text).to eq '0'
    guess :method, browser
    expect(correct.text).to eq '1'
    expect(incorrect.text).to eq '1'

    # I press "i" for "integer", and my "correct" count increases from 1 to 2
    expect(correct.text).to eq '1'
    guess :integer, browser
    expect(correct.text).to eq '2'

    # I see that it is waiting for me to classify the "2" expression
    current_element = page.all('.currentElement').map(&:text).join.delete(" ")
    expect(current_element).to eq '2'

    # I press "m" for "send" (method), and my "correct" count stays at 2 while my "incorrect" count increases from 1 to 2
    expect(correct.text).to eq '2'
    expect(incorrect.text).to eq '1'
    guess :method, browser
    expect(correct.text).to eq '2'
    expect(incorrect.text).to eq '2'

    # I press "i" for "integer", and my "correct" count increases from 2 to 3,
    # and I have completed the challenge
    expect(page).to_not have_css '.summary'
    expect(correct.text).to eq '2'
    guess :integer, browser
    expect(correct.text).to eq '3'
    expect(page).to have_css '.summary'

    # After 1 second, my time has not increased
    time = page.find('.stats .time')
    sleep 1
    expect(time.text).to eq '0:01'

    # I press "return" and it takes me back to the root page
    expect(page.current_path).to eq '/games/integer_addition'
    browser.send_keys(:Return)
    sleep 0.05 # surely there's a better way than this?
    expect(page.current_path).to eq '/'

    # Now I see that all games are scored as unattempted, except "integer addition", which shows my score of 1 second, 3 correct, and 2 incorrect
    expect(page.all('.available_games .completed.score .status').map(&:text)).to eq ['Completed']
    expect(page.all('.available_games .completed.score .time').map(&:text)).to eq ['0:01']
    expect(page.all('.available_games .completed.score .correct').map(&:text)).to eq ['3']
    expect(page.all('.available_games .completed.score .incorrect').map(&:text)).to eq ['2']

    # I have completed 1 game, and have a total of 1 seconds, 3 correct, and 2 incorrect
    expect(page.find '.total_score .games_completed').to have_text '1'
    expect(page.find '.total_score .correct'        ).to have_text '3'
    expect(page.find '.total_score .incorrect'      ).to have_text '2'
    expect(page.find '.total_score .time'           ).to have_text '0:01'
  end
end
