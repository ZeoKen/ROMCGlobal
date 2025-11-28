autoImport("BTCubeCollider")
autoImport("BTSphereCollider")
BTCollider = class("BTCollider")
local ColliderTypes = {Sphere = 1, Cube = 2}
BTCollider.ColliderTypes = ColliderTypes

function BTCollider.CreateColliderWithConfig(config)
  local type = config and config.type
  if type == ColliderTypes.Sphere then
    return BTSphereCollider.new(config.center, config.radius, config.worldToLocalMatrix)
  elseif type == ColliderTypes.Cube then
    return BTCubeCollider.new(config.center, config.extents, config.worldToLocalMatrix)
  end
  return nil
end
