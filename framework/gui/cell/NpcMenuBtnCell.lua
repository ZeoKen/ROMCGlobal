baseCell = autoImport("BaseCell")
NpcMenuBtnCell = class("NpcMenuBtnCell", baseCell)
NpcMenuBtnCell.GuideType = {
  VarietyShop = 10,
  HeadShop = 18,
  PicMake = 21,
  AdventureSkill = 37,
  Teleporter = 160,
  Lottery_Doll = 510,
  TechTree = 513,
  Prestige_Shop = 524,
  DoQuench = 531,
  MountDressing = 528,
  EquipUpgrade = 545,
  strengthen = 1002,
  OpenInheritSkillView = 551
}
NpcMenuBtnCell.Style = {
  Primary = 1,
  Second = 2,
  Normal = 3,
  Grey = 4,
  NpcFuncPrimary = 5,
  NpcFunc_Theme1 = 101,
  NpcFunc_Theme2 = 102
}
local _PrimaryNpcFuncId = {
  [11019] = 1
}
NpcMenuBtnCell.EndTimeShowingCfgMap = {
  [372] = GameConfig.EquipRecovery,
  [373] = GameConfig.EquipRecovery
}

function NpcMenuBtnCell:Init()
  self.bg = self:FindComponent("Bg", UIMultiSprite)
  self.icon = self:FindComponent("Icon", UIMultiSprite)
  self.label = self:FindComponent("Label", UILabel)
  self.labelTrans = self.label.transform
  self.styleExIcon = self:FindComponent("StyleExIcon", UISprite)
  self.endTimeLabel = self:FindComponent("EndTimeLabel", UILabel)
  self.contentTipParent = self:FindGO("ContentTipParent")
  self.contentTip = self:FindGO("ContentTip")
  self.contentLabel = self:FindComponent("ContentLabel", UILabel)
  self.button = self:FindGO("Button")
  self.multiplySymbol = self:FindGO("MultiplySymbol")
  self.multiplySymbol_label = self:FindComponent("muLabel", UILabel, self.multiplySymbol.gameObject)
  self.redTip = self:FindGO("red")
  self.redTip:SetActive(false)
  self.checkmark = self:FindGO("Checkmark")
  self.lockGO = self:FindGO("Lock")
  self.newTag = self:FindGO("NewTag")
  self:SetEvent(self.button, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local longPress = self.button:GetComponent(UILongPress)
  
  function longPress.pressEvent(obj, state)
    if not self.isContentToLong then
      self:TriggerContentTip(state)
    end
  end
  
  self:OveReward()
end

function NpcMenuBtnCell:OveReward()
  self.multiplySymbol_reward = self:FindComponent("Tip", UILabel, self.multiplySymbol.gameObject)
  if BranchMgr.IsSEA() or BranchMgr.IsEU() or BranchMgr.IsNA() then
    if AppBundleConfig.GetSDKLang() ~= "cn" then
      self.multiplySymbol_reward.text = ZhString.OverSea_Reward
    else
      self.multiplySymbol_reward.text = ZhString.Cn_Reward
    end
  else
    self.multiplySymbol_reward.text = ZhString.Cn_Reward
  end
end

function NpcMenuBtnCell:SetData(data)
  self:AddOrRemoveGuideId(self.button)
  self.checkmark:SetActive(false)
  self.lockGO:SetActive(false)
  self.data = data
  local menuType, name = data.menuType, data.name
  local style = NpcMenuBtnCell.Style.Normal
  if menuType == Dialog_MenuData_Type.NpcFunc then
    if data.npcFuncData and _PrimaryNpcFuncId[data.npcFuncData.id] then
      style = NpcMenuBtnCell.Style.NpcFuncPrimary
    else
      style = NpcMenuBtnCell.Style.Normal
    end
    if data.npcFuncData and data.npcFuncData.Parama and data.npcFuncData.Parama.ButtonStyleEx then
      style = data.npcFuncData.Parama.ButtonStyleEx.style
    end
    if data.key then
      local guideId = NpcMenuBtnCell.GuideType[data.key]
      if guideId then
        self:AddOrRemoveGuideId(self.button, guideId)
      end
    end
    if data.npcFuncData and data.npcFuncData.NameEn == "PhotoBoardMyPost" then
      ServicePhotoCmdProxy.Instance:CallBoardQueryAwardPhotoCmd()
    end
    if data.npcFuncData then
      self.redTip:SetActive(self.CheckNpcFuncRedTip(data.npcFuncData) == true)
    else
      self.redTip:SetActive(false)
    end
    self.newTag:SetActive(self.CheckNewTag(data.npcFuncData) == true)
  elseif menuType == Dialog_MenuData_Type.Task then
    local task = data.task
    if task.type == QuestDataType.QuestDataType_MAIN or task.type == QuestDataType.QuestDataType_WANTED then
      style = NpcMenuBtnCell.Style.Primary
    elseif task.type == QuestDataType.QuestDataType_BRANCH then
      style = NpcMenuBtnCell.Style.Second
    else
      style = NpcMenuBtnCell.Style.Normal
    end
  elseif menuType == Dialog_MenuData_Type.Option then
    style = NpcMenuBtnCell.Style.Normal
  elseif menuType == Dialog_MenuData_Type.CustomFunc then
    style = NpcMenuBtnCell.Style.Normal
  elseif menuType == Dialog_MenuData_Type.PveRaidEntrance and data.pvePassInfo then
    self.lockGO:SetActive(data.state == NpcFuncState.Grey)
    self.checkmark:SetActive(data.pvePassInfo:CheckAccPass() or false)
    if data.pvePassInfo.staticEntranceData.staticDifficulty % 10000 == 1 then
      self:AddOrRemoveGuideId(self.button, 550)
    end
  end
  if data.state == NpcFuncState.InActive then
    self.gameObject:SetActive(false)
  else
    self.gameObject:SetActive(true)
    if data.state == NpcFuncState.Grey then
      style = NpcMenuBtnCell.Style.Grey
    end
  end
  self:SetStyle(style)
  self:SetStyleEx()
  self.content = tostring(name)
  self.label.text = self.content
  self.isContentToLong = UIUtil.WrapLabel(self.label)
  self:UpdateMultiplyInfo()
  self:UpdateEndTimeLabel()
end

function NpcMenuBtnCell:SetStyle(style)
  if style ~= self.style then
    self.style = style
    self.styleExIcon.gameObject:SetActive(false)
    self.label.width = 208
    if style == NpcMenuBtnCell.Style.Primary then
      self.bg.CurrentState = 1
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0)
      self:ActiveIcon(true, 0)
    elseif style == NpcMenuBtnCell.Style.Second then
      self.bg.CurrentState = 0
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706)
      self:ActiveIcon(true, 1)
    elseif style == NpcMenuBtnCell.Style.Normal then
      self.bg.CurrentState = 0
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.27058823529411763, 0.37254901960784315, 0.6823529411764706)
      self:ActiveIcon(false)
    elseif style == NpcMenuBtnCell.Style.Grey then
      self.bg.CurrentState = 2
      self.label.color = LuaGeometry.GetTempColor(0.9372549019607843, 0.9372549019607843, 0.9372549019607843)
      self.label.effectColor = LuaGeometry.GetTempColor(0.39215686274509803, 0.40784313725490196, 0.4627450980392157)
      self:ActiveIcon(false)
    elseif style == NpcMenuBtnCell.Style.NpcFuncPrimary then
      self.bg.CurrentState = 1
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0)
      self:ActiveIcon(false)
    elseif style == NpcMenuBtnCell.Style.NpcFunc_Theme1 then
      self.bg.CurrentState = 1
      self.label.color = LuaGeometry.GetTempColor()
      self.label.effectColor = LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0)
      self:ActiveIcon(false)
      self:SetStyleEx()
    end
  end
end

function NpcMenuBtnCell:SetStyleEx()
  if self.data.npcFuncData and self.data.npcFuncData.Parama and self.data.npcFuncData.Parama.ButtonStyleEx then
    local icon = self.data.npcFuncData.Parama.ButtonStyleEx.icon
    if IconManager:SetUIIcon(icon, self.styleExIcon) then
      self.styleExIcon.gameObject:SetActive(true)
      UIUtil.TempLimitIconSize(self.styleExIcon, 50, 50)
      self.label.width = 140
    end
  end
end

function NpcMenuBtnCell:ActiveIcon(b, state)
  b = b and true or false
  self.icon.gameObject:SetActive(b)
  self.labelTrans.localPosition = LuaGeometry.GetTempVector3(b and 10 or 0, self.labelTrans.localPosition.y)
  if b then
    if state then
      self.icon.CurrentState = state
    end
    self.icon:UpdateAnchors()
  end
end

local NpcFunction_Multiply_RewardMap = {
  [1000] = AERewardType.Tower,
  [1100] = AERewardType.Laboratory,
  [1003] = AERewardType.TeamGroup,
  [4015] = AERewardType.GuildRaid,
  [1450] = AERewardType.GuildDojo,
  [10001] = AERewardType.PveCard,
  [10022] = AERewardType.EXPRaid,
  [10140] = AERewardType.ComodoRaid,
  [10141] = AERewardType.SevenRoyalFamiliesRaid
}

function NpcMenuBtnCell:UpdateMultiplyInfo()
  local data = self.data
  if data == nil or data.npcFuncData == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local typeid = data.npcFuncData.id
  if typeid == 1003 then
    local isOpen = ActivityEventProxy.Instance:GetGroupRaidRewardActivityState()
    if isOpen then
      self.multiplySymbol:SetActive(true)
      return
    else
      self.multiplySymbol:SetActive(false)
    end
  end
  if self:GetShowEndTime(typeid) then
    self.multiplySymbol:SetActive(false)
    return
  end
  local rewardType = NpcFunction_Multiply_RewardMap[typeid]
  if rewardType == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local rewardInfo = ActivityEventProxy.Instance:GetRewardByType(rewardType)
  if rewardInfo == nil then
    self.multiplySymbol:SetActive(false)
    return
  end
  local multiply = rewardInfo:GetMultiple() or 1
  if 1 < multiply then
    self.multiplySymbol_label.text = "*" .. multiply
    self.multiplySymbol:SetActive(true)
  else
    self.multiplySymbol:SetActive(false)
  end
end

function NpcMenuBtnCell:UpdateEndTimeLabel()
  local endTime = self:GetShowEndTime()
  self.endTimeLabel.text = endTime and string.format(ZhString.NpcMenuBtnCell_EndTimeFormat, endTime) or ""
  self.label.height = endTime and 25 or 50
  self.labelTrans.localPosition = LuaGeometry.GetTempVector3(self.labelTrans.localPosition.x, endTime and 10.5 or 2.5)
end

local npcFuncEndTimeStrMap

function NpcMenuBtnCell:GetShowEndTime(npcFunctionId)
  if not npcFuncEndTimeStrMap then
    npcFuncEndTimeStrMap = {}
    local str, lower
    for id, cfg in pairs(NpcMenuBtnCell.EndTimeShowingCfgMap) do
      for k, v in pairs(cfg) do
        lower = string.lower(k)
        if EnvChannel.IsTFBranch() then
          if lower == "tfendtime" then
            str = v
            break
          end
        elseif lower == "endtime" then
          str = v
          break
        end
      end
      if str then
        str = string.split(str, " ")[1]
        npcFuncEndTimeStrMap[id] = str
      else
        LogUtility.WarningFormat("Cannot find endtime config of {0}", npcFunctionId)
        TableUtil.Print(cfg)
      end
    end
  end
  if not npcFunctionId then
    local data = self.data and self.data.npcFuncData
    npcFunctionId = data and data.id
  end
  return npcFunctionId and npcFuncEndTimeStrMap[npcFunctionId]
end

function NpcMenuBtnCell:TriggerContentTip(isShow)
  isShow = isShow and true or false
  self.contentTip:SetActive(isShow)
  self.contentTipParent.transform.localPosition = LuaGeometry.GetTempVector3(isShow and 0 or 200, 0)
  if isShow then
    self.contentLabel.text = self.content
  end
end

function NpcMenuBtnCell.CheckNpcFuncRedTip(npcFuncData)
  if not npcFuncData then
    return
  end
  if npcFuncData.NameEn == "PhotoBoardMyPost" then
    return PhotoStandProxy.Instance.mypostHasAward ~= nil
  elseif npcFuncData.id == 600 then
    return RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_SHOP_COUPON)
  end
end

function NpcMenuBtnCell:UpdateRedTip()
  self.redTip:SetActive(self.CheckNpcFuncRedTip(self.data and self.data.npcFuncData) == true)
  self.newTag:SetActive(self.CheckNewTag(self.data and self.data.npcFuncData) == true)
end

function NpcMenuBtnCell.CheckNewTag(npcFuncData)
  if not npcFuncData then
    return false
  end
  if npcFuncData.id == 10000002 then
    return RedTipProxy.Instance:InRedTip(SceneTip_pb.EREDSYS_SHOP_APPEARANCE)
  end
end
