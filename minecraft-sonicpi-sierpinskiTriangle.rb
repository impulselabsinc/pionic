#Sierpinksi spiral translated from pythonfor Sonic Pi by Robin Newman, April 2015
#from https://github.com/brooksc/mcpipy/blob/master//jjinux_sierpinksi_triangle.py
# It goes from -max_xz to max_xz.
max_xz = 128
max_y = 64

# These are the vertices of the triangle. It's a list of points. Each point
# is an (x, y, z) tuple.
triangle_height = max_y - 1
top = [-max_xz, triangle_height, 0]
bottom_left = [max_xz, triangle_height, max_xz]
bottom_right = [max_xz, triangle_height, -max_xz]
triangle_vertices = [top, bottom_left, bottom_right]
puts triangle_vertices

base_block = :sandstone
triangle_block = :diamond #original set to :snow

# This is the maximum number of iterations to let the algorithm run. The
# algorithm relies on randomness, so I'm just picking a sensible value.
max_iterations = max_xz ** 2

print_freq = 1000

use_random_seed(srand())

mc_set_area :air, -max_xz, 0, -max_xz, max_xz, max_y, max_xz
mc_set_area :sandstone, -max_xz, 0, -max_xz, max_xz, -max_y, max_xz

sleep 6 #wait for world to setup (takes longer first run)
mc_teleport 0,20,0 #suitable start viewing point
mc_chat_post "Please wait...."

#define twofuntions
define :random_in_range do
  return rrand_i(-max_xz, max_xz)
end

define :int_average do |a, b|
  return ((a + b) / 2.0).round.to_int
end
#put blocks at triangle vertices
triangle_vertices.each do |l|
  mc_set_block triangle_block,l[0],l[1],l[2]
end
#store current position
current = [random_in_range,triangle_height,random_in_range]
flag=0
  in_thread do #start beeps in a thread
    until flag == 1
      play [:c4,:e4,:g4,:c5,:e5,:c6].choose,release: 0.05
      sleep 0.2
    end
  end

sleep 1

0.upto(max_iterations) do |i| #now iterate to make the pattern

  if i % print_freq == 0 then
    mc_chat_post "Drew "+i.to_s+" blocks" #inform user of progress
  end
  #Pick a random vertex to "walk" towards
  destination = triangle_vertices.choose
  #Draw a block in the middle of the current location and the
  #destination
  cu=current
  de=destination
#work out next current position
  current = [int_average(cu[0],de[0]),triangle_height,int_average(cu[2],de[2])]
  mc_set_block triangle_block,current[0],current[1],current[2] #put block at next point
end

#tell the user where to look....
mc_chat_post "Look upwards to see Siersinski Spiral, coded by Robin Newman"
mc_chat_post "Fly around to fully appreciate the shape"
mc_chat_post "Translated from original Python Program by Jjinux"
sleep 24 #wait for completion
flag=1 #stop the beeps

#when it is drawn and the notes stop, look up to see it. Fly up and around to inspect
