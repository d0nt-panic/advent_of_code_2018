require 'byebug'

def collapse?(a, b)
  return false if a.nil?
  a[0] != b[0] && a[1].downcase == b[1].downcase
end

def react(input)
  output = []

  input.each do |el|
    if collapse?(output.last, el)
      output.pop
    else
      output.push el
    end
  end
  output
end

data = File.read('./day_05_data')

puts data
puts '*'*90

arr_data = []
data.each_char do |char|
  upper = !!/[[:upper:]]/.match(char)
  arr_data << [upper, char]
end

puts arr_data.inspect
puts '*'*90

result_data = react(arr_data)

# puts result_data.inspect
# puts "*"*90

# result_data = result_data.map {|v| v[1]}.join

# puts result_data
puts result_data.size

result_sizes = ('a'..'z').map do |typ|
  temp_arr_data = arr_data.dup
  new_arr_data = temp_arr_data.delete_if { |el| el[1].downcase == typ }

  result_data = react(new_arr_data)
  [typ, result_data.size]
end

puts result_sizes.inspect
puts result_sizes.map { |v| v[1] }.min