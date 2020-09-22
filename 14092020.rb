length = gets.chomp
i=0
initial = "1"
current = initial
nextC = ""
puts initial

while i<length.to_i-1 do
  i = 0
  clen =current.length
  while i<clen do
    p=1
    while (i+1!=clen)&(current[i+1]==current[i]) do
      p+=1
      i+=1
    end
    nextC = nextC + p.to_s+current[i]
    i+=1
  end
  puts nextC
  current = nextC
  nextC=""
  i += 1
end
