require 'synseer/app'

RSpec.describe Synseer::App, integration: true, type: :feature do
  before :all do
    require 'capybara/rspec'
    require "capybara/cuprite"
    Capybara.app            = Synseer::App.from_test_fixtures
    Capybara.default_driver = :cuprite
    Capybara.register_driver(:cuprite) do |app|
      Capybara::Cuprite::Driver.new(app, window_size: [1200, 800])
    end
  end

  class Browser
    include RSpec::Matchers
    attr_accessor :capybara

    def initialize(capybara)
      self.capybara = capybara
    end

    def guess(*types)
      # currently, these are just enough to make them unique, so they will be accepted
      types.each do |type|
        case type
        when :method
          native.send_keys('o')
          native.send_keys('m')
        when :integer
          native.send_keys('j')
          native.send_keys('i')
        when :string
          native.send_keys('j')
          native.send_keys('s')
        else raise "WHAT TYPE IS THIS: #{type.inspect}"
        end
      end
    end

    def assert_game_over
      expect(capybara).to have_css '.summary'
    end

    def assert_game_in_progress
      expect(capybara).to have_no_css '.summary'
    end

    def native
      capybara.find('html').native
    end

    def init_phantom
      capybara.visit '/' unless capybara.current_url == '/'
      capybara.execute_script("localStorage.clear()")
    end

    def click_game_link(game_name)
      capybara.click_link game_name
      expect(capybara.current_path).to eq "/games/#{game_name.gsub " ", "_"}"
    end

    def return_from_game
      expect(capybara.current_path).to start_with '/games'
      native.send_keys(:Return)
      wait_upto(0.5) { expect(capybara.current_path).to eq '/' }
    end

    def wait_upto(duration)
      start_time = Time.now
      while (Time.now - start_time) < duration
        begin
          yield
          return
        rescue RSpec::Expectations::ExpectationNotMetError
          sleep duration/5
        end
      end
      yield
    end

    def code_contains(text)
      line1 = capybara.all('.CodeMirror-line:first-of-type').first
      expect(line1.text).to eq '1 + 2'
    end

    def assert_time_change(before:, sleep_for:, after:)
      expect(capybara.find('.stats .time').text).to eq before
      sleep(sleep_for)
      expect(capybara.find('.stats .time').text).to eq after
    end

    def assert_message(matcher)
      info_box = capybara.find('.infoBox')
      expect(info_box.text).to match matcher
    end

    def assert_completed_games(times: nil, corrects: nil, incorrects: nil)
      expect(
        capybara.all('.available_games .completed.stats .status').map(&:text)
      ).to be_all { |text| text == 'Completed' }

      times and expect(
        capybara.all('.available_games .completed.stats .time').map(&:text)
      ).to eq times

      corrects and expect(
        capybara.all('.available_games .completed.stats .correct').map(&:text)
      ).to eq corrects

      incorrects and expect(
        capybara.all('.available_games .completed.stats .incorrect').map(&:text)
      ).to eq incorrects
    end

    def assert_current_game_task(text)
      current_element = capybara.all('.currentElement').map(&:text).join.delete(" ")
      expect(current_element).to eq text
    end

    def assert_score_change(before_correct:   nil,
                            before_incorrect: nil,
                            before_time:      nil,
                            guesses:          [],
                            after_correct:    nil,
                            after_incorrect:  nil,
                            after_time:       nil,
                            summary:          nil
                          )

      correct   = capybara.find '.stats .correct'
      incorrect = capybara.find '.stats .incorrect'
      time      = capybara.find '.stats .time'

      before_correct   and expect(correct.text  ).to eq before_correct.to_s
      before_incorrect and expect(incorrect.text).to eq before_incorrect.to_s
      before_time      and expect(time.text     ).to eq before_time.to_s
      summary          and expect(capybara).to have_no_css '.summary'

      guess *guesses

      after_correct    and expect(correct.text  ).to eq after_correct.to_s
      after_incorrect  and expect(incorrect.text).to eq after_incorrect.to_s
      after_time       and expect(time.text     ).to eq after_time.to_s
      summary          and expect(capybara.find('.summary').text).to match summary.to_s
    end

    def assert_totals(completed: nil, correct: nil, incorrect: nil, time: nil)
      completed and expect(capybara.find('.total_score .games_completed').text).to eq completed.to_s
      correct   and expect(capybara.find('.total_score .correct'        ).text).to eq correct.to_s
      incorrect and expect(capybara.find('.total_score .incorrect'      ).text).to eq incorrect.to_s
      time      and expect(capybara.find('.total_score .time'           ).text).to eq time.to_s
    end
  end

  def browser
    page.find('html').native
  end

  def capybara
    page
  end

  def ss
    capybara.save_and_open_screenshot
  end

  def lol
    @synseer ||= Browser.new(page)
  end

  before(:each) { lol.init_phantom }

  example 'new user plays their first game' do
    # When I go to the root page, it shows me a listing of syntax games and scores
    capybara.visit '/'
    lol.assert_completed_games times: [], corrects: [], incorrects: []

    # I have completed 0 games, and have a total time of 0 seconds, 0 correct, and 0 incorrect
    lol.assert_totals completed: 0, correct: 0, incorrect: 0, time: '0:00'

    # When I click on the "integer addition" example, it takes me to "/games/integer_addition"
    lol.click_game_link 'integer addition'

    # There is a code display containing the text "1 + 2"
    lol.code_contains '1 + 2'

    # After 1 second, my time has increased from 0 to 1
    lol.assert_time_change before: '0:00', sleep_for: 1, after: '0:01'

    # I see that it is waiting for me to classify the "1 + 2" expression
    lol.assert_current_game_task '1+2'

    # I guess that it is a method, and my "correct" count increases from 0 to 1, it confirms my answer
    lol.assert_score_change before_correct: 0, guesses: [:method], after_correct: 1
    lol.assert_message /\bcorrect.*call/i

    # I see that it is waiting for me to classify the "1" expression
    lol.assert_current_game_task '1'

    # I incorrectl guess that it is a method, my "correct" count stays at 1 while my "incorrect" count increases from 0 to 1
    lol.assert_score_change guesses: [:method],
                            before_correct: 1, before_incorrect: 0,
                            after_correct:  1, after_incorrect:  1
    # It tells me what the correct answer is,
    lol.assert_message /\bincorrect.*int/i

    # I guess that it is an integer, and my "correct" count increases from 1 to 2
    lol.assert_score_change before_correct: 1, guesses: [:integer], after_correct: 2

    # I see that it is waiting for me to classify the "2" expression
    lol.assert_current_game_task '2'

    # I guess that it is a method, and my "correct" count stays at 2 while my "incorrect" count increases from 1 to 2
    lol.assert_score_change guesses: [:method],
                            before_correct: 2, before_incorrect: 1,
                            after_correct:  2, after_incorrect:  2

    # I guess that it is an integer, and my "correct" count increases from 2 to 3,
    # and I have completed the challenge
    lol.assert_score_change guesses: [:integer],
                            before_correct: 2,
                            after_correct:  3,
                            summary: /\b2 incorrect\b/i # just some stat that should be in it

    # After 1 second, my time has not increased
    lol.assert_time_change before: '0:01', sleep_for: 1, after: '0:01'

    # I press "return" and it takes me back to the root page
    lol.return_from_game

    # Now I see that all games are scored as unattempted, except "integer addition", which shows my score of 1 second, 3 correct, and 2 incorrect
    lol.assert_completed_games times: ['0:01'], corrects: ['3'], incorrects: ['2']

    # I have completed 1 game, and have a total of 1 seconds, 3 correct, and 2 incorrect
    lol.assert_totals completed: 1, correct: 3, incorrect: 2, time: '0:01'
  end


  it 'allows me to repeat games with "r", accept next games with "enter", and tracks only my best scores' do
    # Since I am new, I cannot play a previous game
      capybara.visit "/"
      lol.assert_totals completed: 0 # sanity check
      browser.send_keys('r')
      sleep 0.1
      expect(capybara.current_path).to eq '/'

    # I play the first game, 'integer addition', with one error
      browser.send_keys :Return
      sleep 0.1
      expect(capybara.current_path).to eq '/games/integer_addition'

      lol.guess :method # <- error
      lol.guess :method, :integer, :integer
      browser.send_keys(:Return)
      sleep 0.1
      expect(capybara.current_path).to eq '/'

      # I have one error
      lol.assert_totals completed: 1, incorrect: 1

    # I press "r" to replay the game

      browser.send_keys("r")
      sleep 0.1
      expect(capybara.current_path).to eq '/games/integer_addition'

      # I have no errors
      lol.guess :method, :integer, :integer
      browser.send_keys(:Return)
      sleep 0.1
      expect(capybara.current_path).to eq '/'

    # better score replaces the worse score
      lol.assert_totals completed: 1, incorrect: 0

      # I press "r" to replay the game
      browser.send_keys("r")
      sleep 0.1
      expect(capybara.current_path).to eq '/games/integer_addition'

      # I play have one error
      lol.guess :integer # <-- error
      lol.guess :method, :integer, :integer
      browser.send_keys(:Return)
      sleep 0.1
      expect(capybara.current_path).to eq '/'

    # worse score does not beat the better score
      lol.assert_totals completed: 1, incorrect: 0

    # I press enter to play the next game
      browser.send_keys(:Return)
      sleep 0.1
      expect(capybara.current_path).to eq '/games/string_literal'

      # I play with no errors
      lol.guess :string

    # I press enter to go to the main page
      browser.send_keys(:Return)
      sleep 0.1
      expect(capybara.current_path).to eq '/'

      # I have two games played with no errors
      lol.assert_totals completed: 2, incorrect: 0

    # Enter wraps back around
      browser.send_keys(:Return)
      sleep 0.1
      expect(capybara.current_path).to eq '/games/integer_addition'

    # I can press "r" to retry, without going back to the main page
      lol.assert_current_game_task '1+2'
      lol.guess :method, :integer
      lol.assert_current_game_task '2'
      lol.guess :integer
      lol.assert_game_over
      browser.send_keys("r")
      sleep 0.1
      lol.assert_game_in_progress
      lol.assert_current_game_task '1+2'
  end

  it 'filters my keys to the available options as I type, accepts my entry once unique, clears when I press esc, deletes when I press backspace' do
    capybara.visit '/'
    capybara.click_link 'integer addition'

    get_potentials = -> {
      capybara.all('.potential_entries .syntax_node').map(&:text) +
        capybara.all('.potential_entries .entry_group').map(&:text)
    }

    # filters
    lol.assert_current_game_task '1+2'
    expect(get_potentials.call).to include "control-flow"

    browser.send_keys("c")
    expect(get_potentials.call).to include "if statement"
    expect(get_potentials.call).to_not include 'until true'

    browser.send_keys("l")
    expect(get_potentials.call).to include 'until true'
    expect(get_potentials.call).to_not include "if statement"

    # clears
    lol.assert_current_game_task '1+2'
    expect(get_potentials.call).to_not include "control-flow"
    browser.send_keys(:Escape)
    expect(get_potentials.call).to include "control-flow"

    # deletes
    lol.assert_current_game_task '1+2'
    expect(get_potentials.call).to include "control-flow"
    browser.send_keys("c")
    expect(get_potentials.call).to include "loop"
    browser.send_keys("l")
    expect(get_potentials.call).to include "while true"
    browser.send_keys(:Backspace)
    browser.send_keys(:Backspace)
    expect(get_potentials.call).to include "control-flow"

    # accepts
    lol.assert_current_game_task '1+2'
    browser.send_keys("o")
    expect(get_potentials.call).to_not include "control-flow"
    browser.send_keys("m")
    expect(get_potentials.call).to include "control-flow"
  end
end
