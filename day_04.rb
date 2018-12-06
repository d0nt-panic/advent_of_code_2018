require 'time'
require 'byebug'

data = []
File.open("./day_4_data", "r") do |f|
  f.each_line do |line|
    data << line
  end
end

sorted_data = data.sort;nil

REG = /\[(?<timestamp>.+)\] (?<text>.+)/

guards = {}
current_id = nil
prev_min = nil
# current_tmst = nil
sorted_data.each do |str|
  res = str.match(REG)
  tmst = Time.parse(res['timestamp'])
  txt = res['text']

  if txt.include? 'Guard'
    current_id = txt.match(/\d+/).to_s
    # guards[current_id] ||= 0
    guards[current_id] ||= {sleep: 0, range: []}
  elsif txt.include? 'falls asleep'
    prev_min = tmst.min
  elsif txt.include? 'wakes up'
    # byebug
    guards[current_id][:sleep] += tmst.min - prev_min
    guards[current_id][:range] << (prev_min...tmst.min).to_a
  end
end


puts guards
result = guards.max_by { |(_k, v)| v[:sleep] }
puts "*"*90
puts result.inspect
puts "*"*90
guard_most_asleep_id = result[0].to_i
puts guard_most_asleep_id
puts "*"*90
ranges = result[1][:range]


gr_ranges = ranges.flatten.group_by(&:itself)
puts gr_ranges
puts "*"*90
r2 = gr_ranges.max_by { |(_k, v)| v.size }

guard_most_asleep_minuts = r2[0]
puts guard_most_asleep_minuts

result = guard_most_asleep_id * guard_most_asleep_minuts
puts result
puts "*"*90

## PART 2 ##

part_2_res = guards.map do |guard_id, data|
  most_minute_data = data[:range].flatten.group_by(&:itself).max_by { |(_k, v)| v.size }
  next if most_minute_data == nil
  most_minute = most_minute_data[0]
  most_minute_times = most_minute_data[1].size 

  [guard_id, most_minute, most_minute_times]
end.compact

puts part_2_res.inspect
puts "*"*90

guard_2 = part_2_res.max {|arr1, arr2| arr1[2] <=> arr2[2] }
puts guard_2.inspect

puts guard_2[0].to_i * guard_2[1]
