autoImport("NNpc")
NShowNpc = reusableClass("NShowNpc", NNpc)

function NShowNpc:ctor(aiClass)
  NShowNpc.super.ctor(self, aiClass)
end

function NShowNpc:GetCreatureType()
  return Creature_Type.Npc
end

function NShowNpc:InitAssetRole()
  NShowNpc.super.InitAssetRole(self)
  if self.assetRole ~= nil then
    self.assetRole:SetColliderEnable(false)
  end
end
