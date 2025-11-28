autoImport("BaseTip")
NpcScoreTip = class("NpcScoreTip", BaseView)
autoImport("Table_MonsterOrigin")
autoImport("UIGridListCtrl")
autoImport("TipLabelCell")
autoImport("AdvTipRewardCell")
autoImport("UIModelShowConfig")
NpcScoreTip.OganizationIconBGName = "prestige_icon_bg"
NpcScoreTip.OganizationSceneBGName = "com_bg_scene"

function NpcScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("NpcScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self:Init()
end

function NpcScoreTip:Init()
  self.unlockBord = self:FindGO("UnLockBord")
  self.FunctionIcon = self:FindComponent("FunctionIcon", UISprite)
  self.npcname = self:FindComponent("NpcName", UILabel)
  self.objModelTexture = self:FindGO("ModelTexture")
  self.modeltexture = self.objModelTexture:GetComponent(UITexture)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, AdventureTipLabelCell, "AdventureTipLabelCell")
  local modelBg = self:FindGO("ModelBg")
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model then
      self.model:RotateDelta(-delta.x)
    end
  end)
  self:initLockBord()
  self:InitPrestige()
  self:InitPurikura()
end

function NpcScoreTip:adjustPanelDepth(startDepth)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = startDepth or 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end

function NpcScoreTip:initLockBord()
  local obj = self:FindGO("LockBord")
  self.lockBord = self:FindGO("LockBordHolder")
  if not obj then
    obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord)
    obj.name = "LockBord"
  end
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.sprLock = self:FindComponent("Sprite (1)", UISprite, obj)
  self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel)
  
  function self.lockTipLabel.onChange()
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  
  local LockTitle = self:FindComponent("LockTitle", UILabel)
  LockTitle.text = ZhString.MonsterTip_LockTitle
  local LockReward = self:FindComponent("LockReward", UILabel)
  LockReward.text = ZhString.MonsterTip_LockReward
  self.FixAttrCt = self:FindGO("FixAttrCt")
  self:Hide(self.FixAttrCt)
  self.fixedAttrLabel = self:FindComponent("fixedAttrLabel", UILabel)
  local fixLabelCt = self:FindComponent("fixLabelCt", UILabel)
  fixLabelCt.text = ZhString.MonsterTip_FixAttrCt
  local grid = self:FindComponent("LockInfoGrid", UIGrid)
  self.advRewardCtl = UIGridListCtrl.new(grid, AdvTipRewardCell, "AdvTipRewardCell")
  self.modelBottombg = self:FindGO("modelBottombg")
end

function NpcScoreTip:InitPrestige()
  local l_objPrestigeHolder = self:FindGO("PrestigeHolder")
  self.objOganizationPrestige = self:FindGO("Oganization", l_objPrestigeHolder)
  self.objSmallOganizationIcon = self:FindGO("sprSmallOganizationIcon", self.objOganizationPrestige)
  self.sprSmallOganizationIcon = self.objSmallOganizationIcon:GetComponent(UISprite)
  self.labOganizationPrestigeLv = self:FindComponent("labPrestigeLv", UILabel, self.objOganizationPrestige)
  self.sliderOganizationPrestige = self:FindComponent("sliderPrestige", UISlider, self.objOganizationPrestige)
  self.objPersonalPrestige = self:FindGO("Personal")
  self.labPersonalPrestigeLv = self:FindComponent("labPrestigeLv", UILabel, self.objPersonalPrestige)
  self.sliderPersonalPrestige = self:FindComponent("sliderPrestige", UISlider, self.objPersonalPrestige)
  self.objOganizationIcon = self:FindGO("sprOganizationIcon")
  self.sprOganizationIcon = self.objOganizationIcon:GetComponent(UISprite)
  self.texOganizationBG = self:FindComponent("Bg", UITexture, self.objOganizationIcon)
  self.texOganizationSceneBG = self:FindComponent("OganizationBGTexture", UITexture, self.objOganizationIcon)
  PictureManager.Instance:SetUI(NpcScoreTip.OganizationIconBGName, self.texOganizationBG)
  PictureManager.Instance:SetUI(NpcScoreTip.OganizationSceneBGName, self.texOganizationSceneBG)
  self.objGetPathContainer = self:FindGO("GetPathContainer")
  self.objBtnGetPath = self:FindGO("btnGetPath")
  self.labBtnGetPath = self:FindComponent("Label", UILabel, self.objBtnGetPath)
  self:AddClickEvent(self.objBtnGetPath, function()
    self:OnClickBtnGetPath()
  end)
  self.vecOganizationPos = LuaVector3(-238, 0, 0)
  self.vecOganizationPosInNpc = LuaVector3(-199, 0, 0)
end

function NpcScoreTip:InitPurikura()
  self.objPurikuraPanel = self:FindGO("PurikuraPanel")
  self.texPurikuraFrame = self:FindComponent("texFrame", UITexture, self.objPurikuraPanel)
  self.texPurikura = self:FindComponent("texPurikura", UITexture, self.objPurikuraPanel)
  self.objBtnHidePurikura = self:FindGO("btnHidePurikura", self.objPurikuraPanel)
  self:AddClickEvent(self.objBtnHidePurikura, function()
    self.objPurikuraPanel:SetActive(false)
  end)
  self.objBtnShowPurikura = self:FindGO("btnShowPurikura")
  self:AddClickEvent(self.objBtnShowPurikura, function()
    self.objPurikuraPanel:SetActive(true)
  end)
end

function NpcScoreTip:OnEnable()
end

function NpcScoreTip:SetData(npcdata)
  self.data = npcdata
  self:initData()
  self:UpdatePrestige()
  self:UpdateAdvReward()
  self:SetLockState()
  self:UpdateAttriText()
  self:UpdateTopInfo()
  self:UpdatePurikura()
  self:Show3DModel()
  self:adjustPanelDepth(4)
  self:adjustLockRewardPos()
end

function NpcScoreTip:initData()
  if self.data.staticData.MapIcon ~= "" then
    if IconManager:SetMapIcon(self.data.staticData.MapIcon, self.FunctionIcon) then
      self:Show(self.FunctionIcon.gameObject)
      self.FunctionIcon:MakePixelPerfect()
    else
      self:Hide(self.FunctionIcon.gameObject)
    end
  else
    self:Hide(self.FunctionIcon.gameObject)
  end
end

function NpcScoreTip:adjustLockRewardPos()
  local UnlockReward = self:FindGO("UnlockReward")
  self:Hide(UnlockReward)
end

function NpcScoreTip:SetLockState()
  self.isUnlock = false
  if self.data then
    if self.data.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
      self.isUnlock = self.data:IsValid()
    else
      self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
    end
    self.lockTipLabel.text = self.data.staticData.NameZh
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  self.lockBord.gameObject:SetActive(not self.isUnlock)
  if not self.isUnlock then
    self.npcname.text = "????"
    self:Hide(self.modelBottombg)
  else
    self:Show(self.modelBottombg)
  end
  return self.isUnlock
end

function NpcScoreTip:UpdatePrestige()
  local isPrestige = self.data and self.data.type == SceneManual_pb.EMANUALTYPE_PRESTIGE
  local sData = self.data and self.data.staticData
  local isCamp = isPrestige and sData and sData.Type == PrestigeProxy.PrestigeType.Camp
  self.objBtnGetPath:SetActive(isPrestige == true)
  self.objOganizationIcon:SetActive(isCamp == true)
  self.objSmallOganizationIcon:SetActive(not isCamp)
  self.objModelTexture:SetActive(not isCamp)
  if not self.data then
    return
  end
  if isCamp then
    IconManager:SetUIIcon(sData.Emblem, self.sprOganizationIcon)
  end
  local prestigeData
  if isPrestige then
    prestigeData = PrestigeProxy.Instance:GetPrestigeDataByCampID(self.data.staticId)
  elseif self.data.type == SceneManual_pb.EMANUALTYPE_NPC then
    prestigeData = PrestigeProxy.Instance:GetPrestigeDataByNPC(self.data.staticId)
  end
  isCamp = prestigeData and prestigeData.staticData.Type == PrestigeProxy.PrestigeType.Camp
  local isPersonal = prestigeData and prestigeData.staticData.Type == PrestigeProxy.PrestigeType.Personal
  self.objOganizationPrestige:SetActive(isCamp == true)
  self.objPersonalPrestige:SetActive(isPersonal == true)
  if isCamp then
    if not isPrestige then
      IconManager:SetUIIcon(sData.Emblem, self.sprSmallOganizationIcon)
    end
    self.objOganizationPrestige.transform.localPosition = isPrestige and self.vecOganizationPos or self.vecOganizationPosInNpc
    self.labOganizationPrestigeLv.text = prestigeData.level or 1
    self.sliderOganizationPrestige.value = prestigeData:IsGraduate() and 1 or prestigeData.exp / prestigeData:GetMaxExpToNextLevel()
    self.labBtnGetPath.text = ZhString.Adventure_PrestigePath
  elseif isPersonal then
    self.labPersonalPrestigeLv.text = prestigeData.level or 1
    self.sliderPersonalPrestige.value = prestigeData:IsGraduate() and 1 or prestigeData.exp / prestigeData:GetMaxExpToNextLevel()
    self.labBtnGetPath.text = ZhString.Adventure_PersonalPrestigePath
  end
end

function NpcScoreTip:UpdateAdvReward()
  local advReward, advRDatas = self.data.staticData.AdventureReward, {}
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local temp = {}
    temp.type = "AdventureValue"
    temp.value = self.data.staticData.AdventureValue
    table.insert(advRDatas, temp)
  end
  if type(advReward) == "table" then
    if advReward.AdvPoints then
      local temp = {}
      temp.type = "AdvPoints"
      temp.value = advReward.AdvPoints
      table.insert(advRDatas, temp)
    end
    if type(advReward.buffid) == "table" then
      if 0 < #advReward.buffid then
        self:Show(self.FixAttrCt)
      end
      local str = ""
      for i = 1, #advReward.buffid do
        local value = advReward.buffid[i]
        str = str .. (ItemUtil.getBufferDescByIdNotConfigDes(value) or "")
      end
      self.fixedAttrLabel.text = str
    end
    if advReward.item then
      for i = 1, #advReward.item do
        local temp = {}
        temp.type = "item"
        temp.value = advReward.item[i]
        table.insert(advRDatas, temp)
      end
    end
  else
    self:Hide(self.FixAttrCt)
  end
  self.advRewardCtl:ResetDatas(advRDatas)
  local value = 0
  if self.data and self.data.staticData and self.data.staticData.AdventureValue then
    value = self.data.staticData.AdventureValue
  end
  self.adventureValue.text = value
end

function NpcScoreTip:UpdateTopInfo()
  local data = self.data
  local sdata = data and data.staticData
  if sdata then
    self.npcname.text = sdata.NameZh or sdata.Name
  end
end

function NpcScoreTip:UpdatePurikura()
  self.objPurikuraPanel:SetActive(false)
  local staticData = self.data and self.data.staticData
  if not staticData or self.data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK then
    self.objBtnShowPurikura:SetActive(false)
    return
  end
  local havePurikura = staticData.Purikura ~= nil and staticData.Purikura ~= ""
  if havePurikura and staticData.Purikura ~= self.curPurikuraName then
    if self.curPurikuraName then
      PictureManager.Instance:UnLoadNPCLiHui(self.curPurikuraName, self.texPurikura)
    end
    PictureManager.Instance:SetNPCLiHui(staticData.Purikura, self.texPurikura)
    self.curPurikuraName = staticData.Purikura
  end
  local havePurikuraBG = staticData.PurikuraBG ~= nil and staticData.PurikuraBG ~= ""
  if havePurikuraBG and staticData.PurikuraBG ~= self.curPurikuraBGName then
    if self.curPurikuraBGName then
      PictureManager.Instance:UnLoadUI(self.curPurikuraBGName, self.texPurikuraFrame)
    end
    PictureManager.Instance:SetUI(staticData.PurikuraBG, self.texPurikuraFrame)
    self.curPurikuraBGName = staticData.PurikuraBG
  end
  self.objBtnShowPurikura:SetActive((havePurikura and havePurikuraBG) == true)
end

function NpcScoreTip:Show3DModel()
  local data = self.data
  local sdata = data and data.staticData
  if not sdata then
    return
  end
  if self.data.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
    if sdata.Type == PrestigeProxy.PrestigeType.Camp then
      return
    end
    sdata = Table_Npc[sdata.Member[1]]
    if not sdata then
      return
    end
  end
  local otherScale = 1
  if sdata.Shape then
    otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
  else
    helplog(string.format("Npc:%s Not have Shape", sdata.id))
  end
  if sdata.Scale then
    otherScale = sdata.Scale
  end
  if self.model and self.model:Alive() then
    local npcParts = Asset_RoleUtility.CreateNpcRoleParts(sdata.id)
    self.model:Redress(npcParts)
    Asset_Role.DestroyPartArray(npcParts)
  else
    self.model = UIModelUtil.Instance:SetNpcModelTexture(self.modeltexture, sdata.id)
  end
  local showPos = sdata.LoadShowPose
  if showPos and #showPos == 3 then
    self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0))
  end
  if sdata.LoadShowRotate then
    self.model:SetEulerAngleY(sdata.LoadShowRotate)
  end
  if sdata.LoadShowSize then
    otherScale = sdata.LoadShowSize
  end
  self.model:SetScale(otherScale)
end

function NpcScoreTip:GetPrestigeDescription()
  local sdata = self.data.staticData
  local desc = {}
  if sdata.Present ~= "" then
    desc.label = sdata.Present
    desc.hideline = true
    return desc
  end
end

function NpcScoreTip:GetPropDetail()
  local rewards = AdventureDataProxy.Instance:getAppendRewardByTargetId(self.data.staticId, "selfie")
  if not self.data.attrUnlock and rewards and 0 < #rewards then
    local items = ItemUtil.GetRewardItemIdsByTeamId(rewards[1])
    local unlocktip = {}
    unlocktip.hideline = true
    unlocktip.tiplabel = ZhString.MonsterTip_MonstDetail
    unlocktip.label = string.format(ZhString.MonsterTip_UnLockMonstDetail, self.data.staticData.NameZh) .. "{uiicon=Adventure_icon_05}x" .. items[1].num
    return unlocktip
  end
end

function NpcScoreTip:GetDescription()
  if self.isUnlock then
    local sdata = self.data.staticData
    local desc = {}
    if sdata.Desc ~= "" then
      desc.label = sdata.Desc
      desc.hideline = true
      return desc
    end
  end
end

function NpcScoreTip:GetUnlockProp()
  local advReward = self.data.staticData.AdventureReward
  local advalue = self.data.staticData.AdventureValue or 0
  local temp = {}
  temp.hideline = true
  temp.label = {}
  temp.tiplabel = ZhString.MonsterTip_LockProperyReward
  temp.labelType = AdventureDataProxy.LabelType.Status
  local str = "%s, {uiicon=Adventure_icon_05} x%s"
  if advReward.item then
    for i = 1, #advReward.item do
      str = str .. ZhString.FunctionDialogEvent_And .. string.format("{itemicon=%s} x%s", advReward.item[i][1], advReward.item[i][2])
    end
  end
  local rewardStr = string.format(str, AdventureDataProxy.getUnlockCondition(self.data, true), advalue)
  local singleLabel = {
    text = rewardStr,
    unlock = self.isUnlock or false
  }
  table.insert(temp.label, singleLabel)
  return temp
end

function NpcScoreTip:GetBelong()
  if self.isUnlock then
    local sdata = self.data.staticData
    local guild = {}
    if sdata.Guild and sdata.Guild ~= "" then
      local guildTip = sdata.Guild
      guild.label = guildTip
      guild.tiplabel = ZhString.NpcTip_Guild
      guild.hideline = true
      return guild
    end
  end
end

function NpcScoreTip:GetFunction()
  local sdata = self.data.staticData
  local funcConfig = sdata.NpcFunction
  local funcs = {}
  if 0 < #funcConfig then
    local funcsTip = ""
    for i = 1, #funcConfig do
      local type = funcConfig[i].type
      local nfcfg = Table_NpcFunction[type]
      if nfcfg then
        funcsTip = funcsTip .. nfcfg.NameZh
      end
      if i < #funcConfig then
        funcsTip = funcsTip .. ZhString.Common_Comma
      end
    end
    funcs.label = funcsTip
    funcs.tiplabel = ZhString.NpcTip_Func
    funcs.hideline = true
    return funcs
  end
end

function NpcScoreTip:GetPosition()
  local position = {}
  if Table_MonsterOrigin then
    local sdata = self.data.staticData
    local posConfigs = Table_MonsterOrigin[sdata.id]
    if posConfigs and 0 < #posConfigs then
      local posTip = ""
      local filterMap = {}
      for i = 1, #posConfigs do
        local mapID = posConfigs[i].mapID
        local mapdata = Table_Map[mapID]
        if mapdata and not filterMap[mapID] then
          filterMap[mapID] = 1
          posTip = posTip .. mapdata.NameZh
          posTip = posTip .. ZhString.Common_Comma
        end
      end
      local len = StringUtil.getTextLen(posTip)
      posTip = StringUtil.getTextByIndex(posTip, 1, len - 1)
      string.sub(posTip, 1, -2)
      position.label = posTip
      position.tiplabel = ZhString.NpcTip_Position
      position.hideline = true
      return position
    end
  end
end

function NpcScoreTip:UpdateAttriText()
  local data = self.data
  local sdata = data and data.staticData
  local contextDatas = {}
  if data and sdata then
    if data.type == SceneManual_pb.EMANUALTYPE_PRESTIGE then
      local presDesc = self:GetPrestigeDescription()
      if presDesc then
        table.insert(contextDatas, presDesc)
      end
    else
      local desc = self:GetDescription()
      if desc then
        table.insert(contextDatas, desc)
      end
      local func = self:GetFunction()
      if func then
        table.insert(contextDatas, func)
      end
      local belong = self:GetBelong()
      if belong then
        table.insert(contextDatas, belong)
      end
      local position = self:GetPosition()
      if position then
        table.insert(contextDatas, position)
      end
      local unlockProp = self:GetUnlockProp()
      if unlockProp then
        table.insert(contextDatas, unlockProp)
      end
    end
  end
  self.attriCtl:ResetDatas(contextDatas)
end

function NpcScoreTip:OnClickBtnGetPath()
  if self.data.type ~= SceneManual_pb.EMANUALTYPE_PRESTIGE then
    return
  end
  if not self.bdt then
    local sData = self.data and self.data.staticData
    if sData then
      self.bdt = GainWayTip.new(self.objGetPathContainer)
      self.bdt:SetData(sData.ItemID)
      self.bdt:AddEventListener(ItemEvent.GoTraceItem, function()
        self:CloseSelf()
      end, self)
      self.bdt:AddEventListener(GainWayTip.CloseGainWay, function()
        self.bdt = nil
      end, self)
    end
  else
    self.bdt:OnExit()
  end
end

function NpcScoreTip:OnExit()
  self.attriCtl:ResetDatas()
  self.advRewardCtl:ResetDatas()
  UIModelUtil.Instance:ResetTexture(self.modeltexture)
  PictureManager.Instance:UnLoadUI(NpcScoreTip.OganizationIconBGName, self.texOganizationBG)
  PictureManager.Instance:UnLoadUI(NpcScoreTip.OganizationSceneBGName, self.texOganizationSceneBG)
  if self.curPurikuraName then
    PictureManager.Instance:UnLoadNPCLiHui(self.curPurikuraName, self.texPurikura)
    self.curPurikuraName = nil
  end
  if self.curPurikuraBGName then
    PictureManager.Instance:UnLoadUI(self.curPurikuraBGName, self.texPurikuraFrame)
    self.curPurikuraBGName = nil
  end
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  self.model = nil
  NpcScoreTip.super.OnExit(self)
end
