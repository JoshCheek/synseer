require 'io/console'

class Terminal
  all_keys_except_escape = "[^\e]"

  # mostly just ignoring these for now
  non_csi_codes = "\e[^\\[]" # esc followed by non-left bracket

  # not perfect, but a reasonable attempt at CSI codes: https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
  csi_code = "\e"+     # escape
             '\['+     # left bracket
             '\??'+    # optional question mark
             '[\d;]*'+ # any number of digits / semicolons
             '[@-~]'   # asperand through tilde

  ATOMS = /\A(#{all_keys_except_escape}|#{non_csi_codes}|#{csi_code})\z/

  attr_accessor :stdin, :stdout, :height, :width

  def initialize(stdin, stdout)
    self.stdin, self.stdout = stdin, stdout
    self.height, self.width = stdout.winsize
  end

  def atom?(text)
    text =~ ATOMS
  end

  def print(message, col:nil, row:nil)
    if col && row
      preserve_cursor do
        goto col: col, row: row
        stdout.print(message)
      end
    else
      stdout.print(message)
    end
  end

  def control(char)
    (char.to_s.ord - 'a'.ord + 1).chr
  end

  def clear
    print "\e[H\e[2J"
  end

  def horizontal_line(row:)
    print "-" * width, col: 0, row: row
  end


  def goto(col:, row:)
    row = height + row + 1 if row < 0
    col = width  + col + 1 if col < 0
    stdout.print "\e[#{row};#{col}H"
  end

  def each_key(interrupt:)
    stdin.raw do
      loop do
        char = stdin.getc
        if char == interrupt
          Process.kill("INT", Process.pid)
        else
          yield char
        end
      end
    end
  end

  def save_cursor
    print "\e7"
  end

  def restore_cursor
    print "\e8"
  end

  def preserve_cursor
    save_cursor
    yield
  ensure
    restore_cursor
  end
end


class Lesson
  attr_accessor :terminal, :explanation, :expected

  def initialize(terminal, explanation, expected)
    self.terminal, self.explanation, self.expected = terminal, explanation, expected
  end

  def call
    ensure_feedback_menu_is_drawn
    print_explanation
    entry, buffer = "", ""
    terminal.each_key interrupt: terminal.control(:c) do |key|
      entry  << key
      buffer << key
      document_key key
      if terminal.atom?(buffer)
        terminal.print buffer
        buffer = ""
      end
      break if entry.include? expected
    end
  end

  def ensure_feedback_menu_is_drawn
    return if @feedback_menu_drawn
    draw_feedback_menu
  end

  def draw_feedback_menu
    @feedback_menu_drawn = true

    # header line
    terminal.horizontal_line         row: -3
    terminal.print " Instructions ", row: -3, col: 3
    terminal.print " Ascii ",        row: -3, col: -9
    terminal.print " Inspected ",    row: -3, col: -21 # prob max inspection: "\u0003"

    # footer line
    terminal.horizontal_line         row: -1

    # left border
    terminal.print "/",              row: -3, col: 1
    terminal.print "|",              row: -2, col: 1
    terminal.print "\\",             row: -1, col: 1

    # right border
    terminal.print "\\",             row: -3, col: -1
    terminal.print "|",              row: -2, col: -1
    terminal.print "/",              row: -1, col: -1

    # internal
    terminal.print "|",              row: -2, col: -10
    terminal.print "|",              row: -2, col: -22
  end

  def print_explanation
    terminal.print explanation, row: -2, col: 3
  end

  def document_key(key)
    terminal.print '%-10p' % key,     row: -2, col: -20
    terminal.print '%-6d'  % key.ord, row: -2, col: -8
  end

  def redraw
    terminal.clear
    draw_feedback_menu
    print_explanation
  end
end


terminal = Terminal.new $stdin, $stdout

lessons  = [
  Lesson.new(terminal, 'Type the characters "abc"', "abc"),
  Lesson.new(terminal, 'Now hold control and press j, we usually denote this with C-j, this is a newline because it has ascii code 10', 10.chr),
  Lesson.new(terminal, 'Notice how it went down, newlines move it to the next line. Carriage returns, C-m move it to the beginning of the line', 13.chr),
  Lesson.new(terminal, 'Nice, we\'ll use \e to imply escape, press escape', "\e"),
  Lesson.new(terminal, 'Cool, escape codes are how we give more sophisticated commands to the terminal. Try typing "\e[31mred"', "\e[31mred"),
]

current_lesson = lessons.first
trap('SIGWINCH') {
  terminal.height, terminal.width = $stdout.winsize
  current_lesson && current_lesson.redraw
}

terminal.clear
lessons.each do |lesson|
  current_lesson = lesson
  lesson.call
end
