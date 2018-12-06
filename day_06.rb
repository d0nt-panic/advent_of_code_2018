data = []
File.open("./day_06_data", "r") do |f|
  f.each_line do |line|
    data << line
  end
end

# puts data
Struct.new('Point', :x, :y, :closest)
all_points = data.map do |str|
  coords = str.split(', ').map(&:to_i)
  point = Struct::Point.new(coords[0], coords[1])
  point
end
# puts all_points


min_x = all_points.map {|point| point.x }.min
max_x = all_points.map {|point| point.x }.max

min_y = all_points.map {|point| point.y }.min
max_y = all_points.map {|point| point.y }.max


def m_distance(point1, point2)
  (point1.x - point2.x).abs + (point1.y - point2.y).abs
end

def data_distance(target, source)
  m_dist = m_distance(target, source)
  [m_dist, source]
end

def find_distances_to_point(x, y, all_points)
  point_on_map = Struct::Point.new(x, y, nil)
  distances = all_points.map do |point|
    data_distance(point_on_map, point)
  end

  min_dist = distances.min_by {|arr| arr[0] }[0]
  closest_points = distances.map {|arr| arr[1] if arr[0] == min_dist }.compact
  point_on_map.closest = closest_points
  point_on_map
end


bad_points_1 = []
(min_x..max_x).each do |x|
  [min_y, max_y].each do |y|
    point_on_map = find_distances_to_point(x, y, all_points)
    if point_on_map.closest.size == 1
      bad_points_1 << point_on_map.closest.first
    end
  end
end

bad_points_2 = []
[min_x,max_x].each do |x|
  (min_y+1..max_y-1).each do |y|
    point_on_map = find_distances_to_point(x, y, all_points)
    if point_on_map.closest.size == 1
      bad_points_2 << point_on_map.closest.first
    end
  end
end

bad_points = (bad_points_1 + bad_points_2).uniq


good_points = []
on_map = []
(min_x+1..max_x-1).each do |x|
  (min_y+1..max_y-1).each do |y|
    point_on_map = find_distances_to_point(x, y, all_points)
    on_map << point_on_map
    if point_on_map.closest.size == 1
      good_points << point_on_map.closest.first
    end
  end
end

res = good_points.group_by(&:itself).map {|k,v| [k, v.size] }.to_h

res2 = res.delete_if { |k, v| bad_points.include? k }

res2.values.max


### part 2
# in closest now sum of all distances to point
def find_sum_of_distances(x, y, all_points)
  point_on_map = Struct::Point.new(x, y, nil)
  distances = all_points.map do |point|
    data_distance(point_on_map, point)
  end

  point_on_map.closest = distances.map { |arr| arr[0] }.sum
  point_on_map
end

on_map = []
(min_x..max_x).each do |x|
  (min_y..max_y).each do |y|
    point_on_map = find_sum_of_distances(x, y, all_points)
    on_map << point_on_map
  end
end

on_map.count {|point| point.closest < 10_000 }

