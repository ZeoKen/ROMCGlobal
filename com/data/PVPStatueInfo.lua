PVPStatueInfo = class("PVPStatueInfo")

function PVPStatueInfo:ctor(statue_type, data)
  self.statue_type = statue_type
  self.statueInfo = {}
  self.pose = data.statue_info.pose
  self.material = data.statue_info.material
  self:UpdateInfo(data.statue_info)
  self:UpdatePose()
  self.charid = data.statue_info.charid
end

function PVPStatueInfo:Update(data)
  self.statueInfo = {}
  self.pose = data.statue_info.pose
  self.material = data.statue_info.material
  self:UpdateInfo(data.statue_info)
  self:UpdatePose()
end

function PVPStatueInfo:UpdateInfo(statue_info)
  local dirty = false
  for k, v in pairs(statue_info) do
    if self.statueInfo[k] ~= statue_info[k] then
      dirty = true
      self.statueInfo[k] = v
    end
  end
  if dirty then
    local npc = self:GetNpc()
    if npc then
      npc:ReDress()
    else
      redlog("npc nil", self.statue_type)
    end
  end
end

function PVPStatueInfo:UpdatePose(pose, nnpc)
  local curPose = pose or self.pose
  if not curPose then
    return
  end
  local config = Table_ActionAnime[curPose]
  if config then
    local npc = nnpc or self:GetNpc()
    if npc then
      npc:Server_PlayActionCmd(config.Name, nil, true)
    else
      redlog("UpdatePose npc nil", self.statue_type)
    end
  end
end

function PVPStatueInfo:UpdateDefaultMaterial()
  if self.material and self.material ~= 0 then
    return
  end
  local npc = self:GetNpc()
  if npc and npc.assetRole then
    npc.assetRole:SetIgnoreExpression()
    npc.assetRole:SetIgnoreColor()
    npc.assetRole:SetShaderInfo("RO/SP/PartOutlineMatcap", "Public/Shader", "RolePartOutlineSPMatcap", ResourcePathHelper.ModelMainTexture("pub_gold_matcap"), "_SPMatcapMap")
  end
end

function PVPStatueInfo:GetNpc()
  local npcs = NSceneNpcProxy.Instance:FindNpcs(self:GetNPCStaticID())
  return npcs and npcs[1]
end

function PVPStatueInfo:GetNPCStaticID()
  local PvpStatueConfig = GameConfig.PvpStatue
  if not PvpStatueConfig then
    return 0
  end
  if self.statue_type == PvpProxy.StatueType.Triple then
    return PvpStatueConfig.TripleNpcID
  end
  if self.statue_type == PvpProxy.StatueType.Teampws then
    return PvpStatueConfig.TeampwsNpcID
  end
  if self.statue_type == PvpProxy.StatueType.Twelve then
    return PvpStatueConfig.TwelveNpcID
  end
end

function PVPStatueInfo:IsTripple()
  return self.statue_type == PvpProxy.StatueType.Triple
end

function PVPStatueInfo:IsTeampws()
  return self.statue_type == PvpProxy.StatueType.Teampws
end

function PVPStatueInfo:IsTwelve()
  return self.statue_type == PvpProxy.StatueType.Twelve
end
