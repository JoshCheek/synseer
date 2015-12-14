basic_object = {methods: {equal?: 394}, superclass: nil}
object       = {methods: {to_s:   2},   superclass: basic_object}
sting_ray    = {methods: {flap:   1},   superclass: object}
marla        = {class: sting_ray}

marla[:class][:methods][:flap]                             # => 1
marla[:class][:superclass][:methods][:to_s]                # => 2
marla[:class][:superclass][:superclass][:methods][:equal?] # => 394
