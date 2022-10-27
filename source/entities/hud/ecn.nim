import natu/[math, graphics, posprintf, video, tte]
import utils/objs
import types/[hud, scenes]

proc initCenterNumber*(value: sink int, target: sink int): CenterNumber =
  result.initialised = true

  result.value = value
  result.target = target

  result.label.init(vec2i(ScreenWidth div 2, ScreenHeight div 2), s8x16, count = 10)
  result.label.obj.pal = acquireObjPal(gfxShipPlayer)
  result.label.ink = 2 # set the ink colour index to use from the palette
  result.label.shadow = 0 # set the shadow colour (only relevant if the font actually has more than 1 colour)

  posprintf(addr result.hexBuffer, "$%X", result.value)
  result.label.put(addr result.hexBuffer)

proc draw*(self: var CenterNumber; gameStatus: GameStatus) =
  self.label.draw()

  if gameStatus == GameOver:
    let size = tte.getTextSize(addr self.hexBuffer)
    self.label.pos = vec2i(ScreenWidth div 2 - size.x div 2,
      ScreenHeight div 2 - size.y div 2)

    posprintf(addr self.hexBuffer, "GAME OVER")
    self.label.put(addr self.hexBuffer)
  elif gameStatus == LevelUp:
    let size = tte.getTextSize(addr self.hexBuffer)
    self.label.pos = vec2i(ScreenWidth div 2 - size.x div 2,
      ScreenHeight div 2 - size.y div 2)

    posprintf(addr self.hexBuffer, "YOU WON")
    self.label.put(addr self.hexBuffer)
  else:
    let size = tte.getTextSize(addr self.hexBuffer)
    self.label.pos = vec2i(ScreenWidth div 2 - size.x div 2,
      ScreenHeight div 2 - size.y div 2)

    posprintf(addr self.hexBuffer, "$%X", self.value)
    self.label.put(addr self.hexBuffer)


proc update*(self: var CenterNumber) =
  # check if CenterNumber is overflowing or underflowing
  if self.value >= 256:
    self.value -= 256
  if self.value <= -1:
    self.value += 256
