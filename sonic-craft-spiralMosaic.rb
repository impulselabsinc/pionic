#SpiralMosaic in Minecraft coded by Robin Newman, April 2015
use_debug false
mc_set_area :air,-127,-20,-127,127,127,127 #clear a large area in the world
mc_set_area :grass,-60,-1,-60,60,0,60 #to stand on

mc_teleport 0,25,0 #starting position

sleep 6 #wait for this all to complete.
#set up some variables
s=0.05 #gap between placing blocks
angresolution=2 #angular increment between points in degrees

#use Ruby Math package to define some trig stuff
pi=Math::PI #from Ruby Math module
define :cos do |v| #set up call to Math cosine
  return Math.cos(v)
end
define :sin do |v| #set up call to Math sine
  return Math.sin(v)
end
define :rad do |v|
  return v * Math::PI/180
end
define :deg do |v|
  return v * 180/Math::PI
end

l=[] #initialise coordinate list as global

define :setup do |revs,start,increment| #calcs coordinates for spiral pattern
  #params are no of revolutions,start radius, increment scale factor each rev
  l=[] #reset coord list before each setup, as entries are appended
  (0..(360*revs)).step(angresolution) do |i|
    x = (start+increment*rad(i))*cos(rad(i))
    y = (start+increment*rad(i))*sin(rad(i))
    l << [x.round,y.round] #store sets of coordinates in list l
  end
end

define :flatspiral do |xs,ys,zs,revs,start,increment,brick,syn,updown|
  #parameters xs,ys,zs centre of pattern,no of revolutions, start radius...
  #..increment scale factor each rev, birck material, synth to use,..
  #updown =1 to create spiral, 0 to remove it
  n=(360*revs/angresolution).to_int
  with_synth syn do
    if updown==1 then
      setup(revs,start,increment) #calc the coords for this spiral
      in_thread do
        sleep 1.1 #sync time between notes and blocks
        n.times do |i|
          mc_set_block brick, xs+l[i][0],ys+l[i][1],zs #add blocks
          sleep s #inter block gap time
        end
      end
      n.times do |i|
        play 40 +i*70.0/n,release: s #play ascending notes from 40 to 110 pitch
        sleep s #note gap time
      end
    else
      setup(revs,start,increment) #calc coords for thsi spiral
      in_thread do
        sleep 1.1 #sync time between notes and blocks
        n.times do |i|
          mc_set_block :air, xs+l[n-i-1][0],ys+l[n-i-1][1],zs #reset block to air
          sleep s #inter block gap time
        end
      end
      n.times do |i|
        play 40 +( n-i-1)*70.0/n,release: s #play descending notes from 110 to 40
        sleep s
      end
    end
  end
end

define :bodge do # ?rounding errors leave a few blocks. Wipe them with area fill
  mc_set_area :air, -10,10,24,10,30,26
end

#start drawing pattern here with sound accompaniment
#parameters xs,ys,zs centre of pattern,no of revolutions, start radius...
#..increment scale factor each rev, birck material, synth to use,..
#updown =1 to create spiral, 0 to remove it
flatspiral(0,25,25,4,5,0.45,:gold,:fm,1) #add spirals....
flatspiral(0,25,25,4,4,0.45,:diamond,:tri,1)
flatspiral(0,25,25,4,3,0.45,:iron,:tb303,1)
sleep 3
flatspiral(0,25,25,4,3,0.45,:iron,:tb303,0) #remove spirals....
flatspiral(0,25,25,4,4,0.45,:diamond,:tri,0)
flatspiral(0,25,25,4,5,0.45,:gold,:fm,0)
bodge #remove any remaining debris

mc_chat_post "Spiral mosaic coded on Sonic Pi by Robin Newman, April 2015"
