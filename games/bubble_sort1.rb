a = ["e", "a", "c", "b", "d"]
b = 0

while b < a.length
  c = 0
  d = 1

  while d < a.length
    e = a[c]
    f = a[d]
    if f < e
      a[c] = f
      a[d] = e
    end
    c += 1
    d += 1
  end

  b += 1
end

a
