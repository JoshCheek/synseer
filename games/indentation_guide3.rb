# definitions and breakdown of the rules are here:
# https://gist.github.com/JoshCheek/b3c6a8d430b2e1ac8bb2

# if / else / elsif /end
if car.speed > speed_limit
  officer.issue_ticket(car)
else
  officer.eat_donut
end

# unless
unless car.speed > speed_limit
  officer.eat_donut
end

# case / when / else / end
case letter
when "a"
  # ...
when "b"
  # ...
when "c"
  # ...
else
  # ...
end

# or this one
case letter
when "a" then # ...
when "b" then # ...
when "c" then # ...
else # ...
end


# begin / rescue / ensure / else / end
begin
  user.authenticate
rescue AuthenticationError => e
  response.status = 401
ensure
  response.cookies[:requested_url] = request.url
end

# while / end
sum = 0
iterations = 0
while iterations < 3
  iterations += 1
  sum += iterations
end

# until / end
sum = 0
iterations = 0
until iterations >= 3
  iterations += 1
  sum += iterations
end
