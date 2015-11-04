module SyntaxSpray
  class App
    def self.default
      new
    end

    def call(env)
      body = <<-BODY
        <!DOCTYPE html>
        <html>
        <body>
        <div class="available_games">game</div>
        </body>
        </html>
      BODY
      [200,{'Content-Type' => 'text/html', 'Content-Length' => body.length.to_s},[body]]
    end
  end
end
