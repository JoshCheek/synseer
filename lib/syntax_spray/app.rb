module SyntaxSpray
  class App
    def self.call(env)
      [200,{'Content-Type' => 'text/html', 'Content-Length' => '14'},["<h1>hello</h1>"]]
    end
  end
end
