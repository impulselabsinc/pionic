#Sonic Pi musical cube building in Minecraft by Robin Newman, April 2015
#First wipe out a large area of existing world
mc_set_area :air,-100,-20,-100,100,100,100
mc_set_area :grass,-10,-10,-10,10,-9,10 #to stand on
#teleport to viewing point
mc_teleport 0,-8,0
#Wait for MC screen to initialise
sleep 6 #may require longer on first run depending on initial world
#also you may haev to search to find the strucvture. (Look up a bit)

s=0.1 #interval between successive block placement (and notes "plays")
t=0.2 #interval between cube build stages
#brick type variables
a=:air
g=:gold
d=:diamond
b=:brick
ir=:iron
#define block building function
#parameters centre coords of cube,half side size,synth for notes,pillar material...
#....links material,updown=1 build,0 remove,starting note pitch
define :musicalblock do |p,sz,syn,b1,b2,updown,startnote|
  in_thread do #build blocks in thread
    sleep 1.6 #delay time to sync music and cubes
    if updown==1 then #we are building...
      1.upto(2*sz) do |i| #build pillers
        mc_set_block b1,p[0]-sz,p[1]-sz+i,p[2]-sz
        mc_set_block b1,p[0]+sz,p[1]-sz+i,p[2]-sz
        mc_set_block b1,p[0]-sz,p[1]-sz+i,p[2]+sz
        mc_set_block b1,p[0]+sz,p[1]-sz+i,p[2]+sz
        sleep s
      end
      sleep t
      1.upto(2*sz-1) do |i| #build top links
        mc_set_block b2,p[0]-sz+i,p[1]+sz,p[2]-sz
        mc_set_block b2,p[0]-sz+i,p[1]+sz,p[2]+sz
        mc_set_block b2,p[0]-sz,p[1]+sz,p[2]-sz+i
        mc_set_block b2,p[0]+sz,p[1]+sz,p[2]-sz+i
        sleep s
      end
      sleep t
      1.upto(2*sz-1) do |i| #build bottom links
        mc_set_block b2,p[0]-sz+i,p[1]-sz+1,p[2]-sz
        mc_set_block b2,p[0]-sz+i,p[1]-sz+1,p[2]+sz
        mc_set_block b2,p[0]-sz,p[1]-sz+1,p[2]-sz+i
        mc_set_block b2,p[0]+sz,p[1]-sz+1,p[2]-sz+i
        sleep s
      end
    else #we are removing...
      (2*sz-1).downto(1) do |i| #remove bottom links
        mc_set_block a,p[0]-sz+i,p[1]-sz+1,p[2]-sz
        mc_set_block a,p[0]-sz+i,p[1]-sz+1,p[2]+sz
        mc_set_block a,p[0]-sz,p[1]-sz+1,p[2]-sz+i
        mc_set_block a,p[0]+sz,p[1]-sz+1,p[2]-sz+i
        sleep s
      end
      sleep t
      (2*sz).downto(1) do |i|
        mc_set_block a,p[0]-sz+i,p[1]+sz,p[2]-sz #remove top links
        mc_set_block a,p[0]-sz+i,p[1]+sz,p[2]+sz
        mc_set_block a,p[0]-sz,p[1]+sz,p[2]-sz+i
        mc_set_block a,p[0]+sz,p[1]+sz,p[2]-sz+i
        sleep s
      end
      sleep t
      (2*sz).downto(1) do |i| #remove pillars
        mc_set_block a,p[0]-sz,p[1]-sz+i,p[2]-sz
        mc_set_block a,p[0]+sz,p[1]-sz+i,p[2]-sz
        mc_set_block a,p[0]-sz,p[1]-sz+i,p[2]+sz
        mc_set_block a,p[0]+sz,p[1]-sz+i,p[2]+sz
        sleep s

      end
    end
  end
  with_fx :reverb,room: 0.8 do
    with_synth syn do #now play the notes synced to the block changes....
      if updown == 1 then #building cube music
        1.upto(2*sz) do |i| #play with pillar build
          sleep s
          play startnote+i,release: s*0.95
        end
        sleep t
        1.upto(2*sz-1) do |i| #play with toplink build
          sleep s
          play startnote+2*sz+i,release: s*0.95
        end
        sleep t
        1.upto(2*sz-1) do |i| #play with bottom link build
          sleep s
          play startnote+4*sz-1+i,release: s*0.95
        end
      else
        (2*sz-1).downto(1) do |i|
          sleep s
          play startnote+4*sz-1+i,release: s*0.95 #play with bottom link removal
        end
        sleep t
        (2*sz-1).downto(1) do |i| #play with top link removal
          sleep s
          play startnote+2*sz+i,release: s*0.95
        end
        sleep t
        (2*sz).downto(1) do |i| #play with pillar removal
          sleep s
          play startnote+i,release: s*0.95
        end
      end
    end
  end
end
#paramaters are [x,y,z] for centre,half side size,pillar material, link material,updown (= 1 to build),starting pitch
#start building cubes (updown=1)
musicalblock([10,30,30],5,:prophet,d,g,1,60) #far top left cube
sleep 1
musicalblock([-10,30,30],5,:tb303,d,g,1,60) #far top right cube
sleep 1
musicalblock([0,20,20],10,:fm,d,g,1,55) #main large centra cube
sleep 1
musicalblock([10,30,10],5,:prophet,d,g,1,60) #near top left cube
sleep 1
musicalblock([-10,30,10],5,:tb303,d,g,1,60) #near top right cube
sleep 1
musicalblock([10,10,10],5,:dsaw,d,g,1,60) #near bottom left cube
sleep 1
musicalblock([-10,10,10],5,:zawa,d,g,1,60) #near bottom right cube
sleep 1
musicalblock([10,10,30],5,:dsaw,d,g,1,60) #far bottom left cube
sleep 1
musicalblock([-10,10,30],5,:zawa,d,g,1,60) #far bottom right cube
sleep 1
musicalblock([0,15,20],4,:fm,b,ir,1,60) #small central cube
sleep 2

#now start removing cubes (updown=0) reverse building order
musicalblock([0,15,20],4,:fm,b,ir,0,60) #small central cube
sleep 1
musicalblock([-10,10,30],5,:zawa,d,g,0,60) #far bottom right cube
sleep 1
musicalblock([10,10,30],5,:dsaw,d,g,0,60) #far bottom left cube
sleep 1
musicalblock([-10,10,10],5,:zawa,d,g,0,60) #near bottom right cube
sleep 1
musicalblock([10,10,10],5,:dsaw,d,g,0,60) #near bottom left cube
sleep 1
musicalblock([-10,30,10],5,:tb303,d,g,0,60) #near top right cube
sleep 1
musicalblock([10,30,10],5,:prophet,d,g,0,60) #near top left cube
sleep 1
musicalblock([0,20,20],10,:fm,d,g,0,55) #main large central cube
sleep 1
musicalblock([-10,30,30],5,:tb303,d,g,0,60) #far top right cube
sleep 1
musicalblock([10,30,30],5,:prophet,d,g,0,60) #far top left cube
sleep 2
mc_chat_post "Coded for Sonic-Pi by Robin Newman, April 2015"
