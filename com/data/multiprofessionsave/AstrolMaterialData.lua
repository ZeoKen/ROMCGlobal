AstrolMaterialData = class("AstrolMaterialData")

function AstrolMaterialData:ctor(serverdata)
  self.charid = serverdata.charid
  self.cost = {}
  if serverdata.materials then
    local n = #serverdata.materials
    for i = 1, n do
      local single = serverdata.materials[i]
      if self.cost[single.id] == nil then
        self.cost[single.id] = single.count
      else
        self.cost[single.id] = self.cost[single.id] + single.count
      end
    end
  end
end

function AstrolMaterialData:GetContribute()
  return self.cost[AstrolabeProxy.ContributeItemId]
end

function AstrolMaterialData:GetGoldMedal()
  return self.cost[AstrolabeProxy.GoldMedalItemId]
end
