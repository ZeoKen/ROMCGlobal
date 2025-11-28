local BaseCell = autoImport("BaseCell")
PlayerFaceCell = class("PlayerFaceCell", BaseCell)
autoImport("HeadIconCell")
autoImport("FrameCell")
PlayerFaceCell_SymbolType = {
  JoinHand = "SymbolType_JoinHand",
  Follow = "SymbolType_Follow",
  ImageCreate = "SymbolType_ImageCreate"
}
local tempV3 = LuaVector3(0, 4.5, 0)
local _PrestigeOutlineColor = {
  [1] = LuaColor.New(0.8, 0.2549019607843137, 0.24705882352941178, 1),
  [2] = LuaColor.New(0.7568627450980392, 0.17647058823529413, 0.4470588235294118, 1)
}

function PlayerFaceCell:Init()
  self.lvmat = "Lv.%s"
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindComponent("Icon", UISprite, self.profession)
  self.proColor = self:FindComponent("Color", UISprite, self.profession)
  if self.proIcon then
    self.proIcon.transform.localPosition = tempV3
  end
  if self.proColor then
    self.proColor.width = 32
    self.proColor.height = 32
    self.proColor.spriteName = "com_icon_profession"
    self.proColor.transform.localPosition = tempV3
  end
  self.name = self:FindComponent("name", UILabel)
  if self.name then
    self.nameObj = self.name.gameObject
  end
  self.level = self:FindComponent("level", UILabel)
  self.vip = self:FindComponent("vip", UILabel)
  self.hp = self:FindComponent("hp", UISlider)
  self.mp = self:FindComponent("mp", UISlider)
  self.levelBg = self:FindGO("bg_head")
  self.leadsymbol1 = self:FindGO("leadsymbol1")
  self.leadsymbol2 = self:FindGO("leadsymbol2")
  self.groupleadsymbol1 = self:FindGO("GroupLeadSymbol1", self.leadsymbol1)
  self.groupleadsymbol2 = self:FindGO("GroupLeadSymbol2", self.leadsymbol2)
  self:InitHeadIconCell()
  self:UpdateHeadIconPos()
  local frameObj = self:FindGO("PlayerFrameCell")
  if frameObj then
    self.frame = FrameCell.new(frameObj)
  end
  self.zoneid = self:FindComponent("Zone", UILabel)
  self:InitSymbols()
  self:AddCellClickEvent()
end

function PlayerFaceCell:InitHeadIconCell()
  self.headIconCell = HeadIconCell.new()
  self.headIconCell:CreateSelf(self.gameObject)
  self.headIconCell:SetMinDepth(3)
end

function PlayerFaceCell:InitSymbols()
  self.symbols = {}
  self.symbols.rePosition = self:FindComponent("SymbolsGrid", UIGrid)
  if self.symbols.rePosition then
    self.symbols.symbolGridTrans = self.symbols.rePosition.gameObject.transform
  end
  self.symbols[PlayerFaceCell_SymbolType.ImageCreate] = self:FindComponent("ImageCreateor", UISprite)
  self.symbols[PlayerFaceCell_SymbolType.Follow] = self:FindComponent("FollowState", UISprite)
  
  function self.symbols.RePosition(symbols)
    if symbols.rePosition then
      symbols.rePosition:Reposition()
    end
  end
  
  function self.symbols.SetSprite(symbols, symbolType, spriteName)
    if symbols[symbolType] then
      symbols[symbolType].spriteName = spriteName
    end
  end
  
  function self.symbols.Active(symbols, symbolType, b)
    if symbols[symbolType] then
      symbols[symbolType].gameObject:SetActive(b)
      symbols:RePosition()
    end
  end
end

function PlayerFaceCell:SetSymbolObjPos(v)
  self.symbols.symbolGridTrans.localPosition = v
end

function PlayerFaceCell:HideHpMp()
  self:Hide(self.hp)
  self:Hide(self.mp)
  self:UpdateHeadIconPos()
end

function PlayerFaceCell:UpdateHeadIconPos()
  if self.headIconCell == nil then
    return
  end
  self:SetHeadIconPos(self.hp and self.mp and self.hp.gameObject.activeSelf and self.mp.gameObject.activeSelf)
end

function PlayerFaceCell:SetHeadIconPos(isUp)
  if isUp then
    self.headIconCell:SetIconLoaclPosXYZ(0, 17, 0)
  else
    self.headIconCell:SetIconLoaclPosXYZ(0, 0, 0)
  end
end

function PlayerFaceCell:HideLevel()
  self:Hide(self.level.gameObject)
  self:Hide(self.levelBg)
end

function PlayerFaceCell:SetData(data)
  self.data = data
  self:LowFreqRefresh()
end

function PlayerFaceCell:LowFreqRefresh()
  if not self.refreshCD then
    self.refreshCD = 1
    self:RefreshSelf()
    self.timeTickId = self.timeTickId == nil and 1 or self.timeTickId + 1
    TimeTickManager.Me():CreateTick(6000 * UnityDeltaTime, 33, function()
      if not GameObjectUtil.Instance:ObjectIsNULL(self.gameObject) then
        if self.refreshCD == 2 then
          self.refreshCD = nil
          self:LowFreqRefresh()
        else
          self.refreshCD = nil
        end
      end
    end, self, self.timeTickId, false, 1)
  else
    self.refreshCD = 2
  end
end

function PlayerFaceCell:RefreshSelf(data)
  data = data or self.data
  if nil == data then
    self:Hide()
    return
  end
  self:Show()
  self:SetName(data.name)
  if self.headIconCell and data.iconData then
    if data.iconData.type == HeadImageIconType.Avatar then
      self.headIconCell:SetData(data.iconData)
    elseif data.iconData.type == HeadImageIconType.Simple then
      self.headIconCell:SetSimpleIcon(data.iconData.icon, data.iconData.frameType, data.iconData.isMyself)
      self.headIconCell:SetPortraitFrame(data.iconData.portraitframe)
      self.headIconCell:SetAfkIcon(data.iconData.afk)
    end
    if data.offline == true and not AfkProxy.ParseIsAfk(data.iconData.afk) then
      self:SetIconActive(false, true)
    elseif data.canExpire ~= true then
      self:SetIconActive(true, true)
    end
  end
  self:SetPlayerPro(data)
  self:SetLevel(data.level)
  if self.vip then
    self.vip.text = data.vip and string.format("Lv.%s", data.vip) or ""
  end
  local zone = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
  if self.zoneid then
    self.zoneid.gameObject:SetActive(zone ~= "" and data.zoneid ~= MyselfProxy.Instance:GetZoneId())
    self.zoneid.text = zone
  end
  self:SetTeamLeaderSymbol(data.job, data.groupTeamIndex == 1)
  self:UpdateHp(data.hp)
  self:UpdateMp(data.mp)
  self:RefreshPrestigeLevel()
end

function PlayerFaceCell:SetName(name)
  if self.cache_name == name then
    return
  end
  self.cache_name = name
  if self.name == nil then
    return
  end
  self.name.text = name or ""
  UIUtil.WrapLabel(self.name)
end

function PlayerFaceCell:SetLevel(lv)
  if self.cache_lv == lv then
    return
  end
  self.cache_lv = lv
  if self.level == nil then
    return
  end
  self.level.text = string.format(self.lvmat, lv or "")
end

function PlayerFaceCell:SetPlayerPro(data)
  if self.profession then
    if data.isMonster then
      self.profession.gameObject:SetActive(false)
      return
    end
    if type(data.profession) == "number" then
      local proData = Table_Class[data.profession]
      if proData then
        if IconManager:SetNewProfessionIcon(proData.icon, self.proIcon) then
          self.profession.gameObject:SetActive(true)
          local colorKey = "CareerIconBg" .. proData.Type
          self.proColorSave = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
          self.proColor.color = self.proColorSave
        else
          self.profession.gameObject:SetActive(false)
        end
      else
        errorLog(string.format("%d not Config", data.profession))
      end
    elseif type(data.profession) == "string" then
      if IconManager:SetNewProfessionIcon(data.profession, self.proIcon) or IconManager:SetUIIcon(data.profession, self.proIcon) then
        self.profession.gameObject:SetActive(true)
      else
        self.profession.gameObject:SetActive(false)
      end
    else
      self.profession.gameObject:SetActive(false)
    end
    self.proIcon.width = 32
    self:SetGoGrey(self.proColor, data.offline and not AfkProxy.ParseIsAfk(self.data and self.data.iconData and self.data.iconData.afk))
  end
end

function PlayerFaceCell:SetIconActive(b, anim)
  self.headIconCell:SetActive(b, anim)
end

function PlayerFaceCell:SetGoGrey(go, isTo)
  if isTo then
    self:SetTextureColor(go, ColorUtil.NGUIGray)
  else
    self:SetTextureWhite(go)
    if self.proColorSave ~= nil then
      self.proColor.color = self.proColorSave
    end
  end
end

function PlayerFaceCell:SetGoGreyMP()
  self:SetIconActive(false, true)
  redlog("[afk] setgogreymp")
  self.profession = self:FindGO("profession")
  local sprites = UIUtil.GetAllComponentsInChildren(self.profession, UISprite, true)
  local color = LuaGeometry.GetTempColor(0.00392156862745098, 0.00784313725490196, 0.011764705882352941)
  for i = 1, #sprites do
    sprites[i].color = color
  end
end

function PlayerFaceCell:SetGoNormalMP()
  self:SetIconActive(true, true)
  self.profession = self:FindGO("profession")
  local sprites = UIUtil.GetAllComponentsInChildren(self.profession, UISprite, true)
  local color = LuaGeometry.GetTempColor(1, 1, 1)
  for i = 1, #sprites do
    sprites[i].color = color
  end
  if self.proColorSave ~= nil then
    self.proColor.color = self.proColorSave
  end
end

function PlayerFaceCell:SetTeamLeaderSymbol(jobType, isLeaderTeamInGroup)
  if isLeaderTeamInGroup == nil then
    local myTeamData = TeamProxy.Instance.myTeam
    isLeaderTeamInGroup = myTeamData and myTeamData:IsLeaderTeamInGroup()
  end
  if self.leadsymbol1 then
    local isLeader = jobType == SessionTeam_pb.ETEAMJOB_LEADER
    self.leadsymbol1:SetActive(isLeader)
    if self.groupleadsymbol1 then
      self.groupleadsymbol1:SetActive((isLeaderTeamInGroup and isLeader) == true)
    end
  end
  if self.leadsymbol2 then
    local isTmpLeader = jobType == SessionTeam_pb.ETEAMJOB_TEMPLEADER and not self.data.offline
    self.leadsymbol2:SetActive(isTmpLeader)
    if self.groupleadsymbol2 then
      self.groupleadsymbol2:SetActive((isLeaderTeamInGroup and isTmpLeader) == true)
    end
  end
end

function PlayerFaceCell:UpdateHp(value)
  if self.hp ~= nil and value ~= nil then
    value = math.floor(value * 100) / 100
    self.hp.value = value
  end
end

function PlayerFaceCell:UpdateMp(value)
  if self.mp ~= nil and value ~= nil then
    value = math.floor(value * 100) / 100
    self.mp.value = value
  end
end

function PlayerFaceCell:UpdateVoice(value)
  if not self.headIconCell or self.VoiceBan == true then
  elseif value == true then
    self.headIconCell:SetVoiceState(HeadVoiceState.Open)
  else
    self.headIconCell:SetVoiceState(HeadVoiceState.Close)
  end
end

function PlayerFaceCell:SetVoiceBan(value)
  if self.headIconCell then
    if value == true then
      self.VoiceBan = true
      self.headIconCell:SetVoiceState(HeadVoiceState.Ban)
    else
      self.VoiceBan = false
    end
  end
end

function PlayerFaceCell:AddIconEvent()
  if self.headIconCell then
    self.headIconCell:OnAdd()
  end
end

function PlayerFaceCell:RemoveIconEvent()
  if self.headIconCell then
    self.headIconCell:OnRemove()
  end
end

function PlayerFaceCell:SetMinDepth(minDepth)
  self.headIconCell:SetMinDepth(minDepth)
end

function PlayerFaceCell:UpdateNameDepth()
  if self.name and self.headIconCell and self.headIconCell.afkIcon then
    if not self.originNameDepth then
      self.originNameDepth = self.name.depth
    end
    if self.headIconCell.afkIcon.gameObject.activeSelf then
      self.name.depth = self.headIconCell.afkIcon.depth - 1
    else
      self.name.depth = self.originNameDepth
    end
  end
end

function PlayerFaceCell:HideIcon()
  self.headIconCell:Hide(self.headIconCell.avatarPars)
  self.headIconCell:Hide(self.headIconCell.simpleIcon.gameObject)
end

function PlayerFaceCell:ActiveCell(b)
  self.gameObject:SetActive(b)
end

function PlayerFaceCell:ActiveSelf()
  return self.gameObject.activeSelf
end

function PlayerFaceCell:ActiveHpMp(bool)
  self.hp.gameObject:SetActive(bool)
  self.mp.gameObject:SetActive(bool)
end

function PlayerFaceCell:RefreshPrestigeLevel(level)
  local mapConfig = GameConfig.Prestige.ValidMap
  if not mapConfig then
    if self.prestigeGO then
      self.prestigeGO:SetActive(false)
    end
    return
  end
  local curMap = Game.MapManager:GetMapID()
  local prestigeVersion = mapConfig[curMap]
  if not prestigeVersion then
    if self.prestigeGO then
      self.prestigeGO:SetActive(false)
    end
    return
  end
  local menuid = GameConfig.Prestige.PrestigeUnlockMenu and GameConfig.Prestige.PrestigeUnlockMenu[prestigeVersion]
  if not menuid or FunctionUnLockFunc.Me():CheckCanOpen(menuid) then
    local prestigeLevel = level or self.data and self.data.prestigeLevel or 0
    if self.prestigeGO then
      self.prestigeGO:SetActive(true)
      self.prestigeBg.CurrentState = prestigeVersion - 1
      self.prestigeLevel.text = prestigeLevel
      self.prestigeLevel.effectColor = _PrestigeOutlineColor[prestigeVersion]
    end
  elseif self.prestigeGO then
    self.prestigeGO:SetActive(false)
  end
end
