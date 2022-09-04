import natu/[math, graphics, video, bios, input, mgba]
import ../utils/objs
import ../components/[shooter, projectile]


#TODO(Kal): Use the `Graphics` enum instead of calling gfxShipTemp, etc directly

type PlayerShip* = object
  initialised: bool
  tileId, paletteId: int
  orbitRadius: Vec2i
  centerPoint: Vec2i
  pos*: Vec2f
  angle: Angle

  shooter: Shooter
  bulPlayerProj*: Projectile

# constructor - create a ship object
proc initPlayerShip*(pos: Vec2f): PlayerShip =
  result.initialised = true # you should add an extra field
  result.orbitRadius = vec2i(90, 60)
  result.pos = pos
  result.angle = 0
  result.centerPoint = vec2i(ScreenWidth div 2, ScreenHeight div 2)
  result.tileId = allocObjTiles(gfxShipTemp)
  result.paletteId = acquireObjPal(gfxShipTemp)

  result.shooter = initShooter()


# destructor - free the resources used by a ship object
proc `=destroy`*(self: var PlayerShip) =
  if self.initialised:
    self.initialised = false
    freeObjTiles(self.tileId)
    releaseObjPal(gfxShipTemp)
    self.shooter.destroy()

proc `=copy`*(dest: var PlayerShip; source: PlayerShip) {.error: "Not implemented".}

# draw ship sprite and all the affine snazziness
proc draw*(self: PlayerShip) =
  self.shooter.draw()

  copyFrame(addr objTileMem[self.tileId], gfxShipTemp, 0)
  withObjAndAff:
    let delta = self.centerPoint - self.pos
    aff.setToRotationInv(ArcTan2(int16(delta.x), int16(delta.y)))
    obj.init:
      mode = omAff
      affId = affId
      pos = vec2i(self.pos) - vec2i(gfxShipTemp.width div 2,
          gfxShipTemp.height div 2)
      size = gfxShipTemp.size
      tileId = self.tileId
      palId = self.paletteId

  # printf("in playership.nim proc draw x = %l, y = %l", self.pos.x.toInt(), self.pos.y.toInt())

# ship controls
proc controls*(self: var PlayerShip) =
  if keyIsDown(kiLeft):
    self.angle += 350
  if keyIsDown(kiRight):
    self.angle -= 350
  if keyHit(kiA):
    self.bulPlayerProj = initBulletPlayerProjectile(gfxBulletTemp)
    self.shooter.fire(
      projectile = self.bulPlayerProj, pos = self.pos, angle = self.angle)
    
    # printf("in playership.nim proc controls x = %l, y = %l", self.pos.x.toInt(),
    #     self.pos.y.toInt())

# calculate and update ship position
proc update*(self: var PlayerShip) =

  self.pos.x = self.centerPoint.x + fp(luCos(
      self.angle) * self.orbitRadius.x)
  self.pos.y = self.centerPoint.y + fp(luSin(
      self.angle) * self.orbitRadius.y)

  self.shooter.update()