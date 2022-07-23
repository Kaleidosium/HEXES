import natu/[video, bios, irq, input, math, graphics]
import utils/objs
import components/[playership]

# TODO(Kal): change this to rgb8() later
# background color, approximating eigengrau
bgColorBuf[0] = rgb5(3, 3, 4)

# enable VBlank interrupt so we can wait for the end of the frame without burning CPU cycles
irq.enable(iiVBlank)

dispcnt = initDispCnt(obj = true, obj1d = true)

irq.enable(iiVBlank)

# create a ship, 75 is orbitRadius:
var playerShipInstance = initPlayerShip(vec2i(75, 0))
# create a bullet where the playerShip is
# var bulletInstance = initBullet(playerShipInstance.pos)


while true:
  # update key states
  keyPoll()

  # ship controls
  playerShipInstance.controls()

  # wait for the end of the frame
  VBlankIntrWait()

  # update ship position
  playerShipInstance.updatePos()
  # draw the ship
  playerShipInstance.draw()

  # copy the PAL RAM buffer into the real PAL RAM.
  flushPals()
  # hide all the objects that weren't used
  oamUpdate()
