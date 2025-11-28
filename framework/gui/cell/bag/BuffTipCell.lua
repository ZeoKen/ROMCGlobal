autoImport("FoodBuffCell")
local BaseCell = autoImport("BaseCell")
BuffTipCell = class("BuffTipCell", BaseCell)
local BUFFTYPE_DOUBLEEXPCARD = "MultiTime"
local SpecialBuffType = {
  MultiTime = {
    Desc = ZhString.BuffCell_DELeftTimeTip
  },
  MultiExp = {
    Desc = ZhString.BuffCell_OffLineExpLeftTimeTip
  },
  MultiItem = {
    Desc = ZhString.BuffCell_OffLineItemLeftTimeTip
  }
}
local PerfectServiceBuffType = "PerfectService"

function BuffTipCell:Init()
  self:InitNormalCell()
end

function BuffTipCell:InitNormalCell()
  self.mask = self:FindComponent("Mask", UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.layer = self:FindComponent("Layer", UILabel)
  self.desc = self:FindComponent("desc", UILabel)
  self.extend = self:FindComponent("extend", UILabel)
  self.countdown = self:FindComponent("countdown", UILabel)
  self.widgetContainer = self:FindComponent("Container", UIWidget)
  self.Sprite = self:FindGO("Sprite")
  self.name = self:FindComponent("name", UILabel)
  self.switchBtn = self:FindGO("SwitchBtn")
  self.switchBtn_BGSprite = self.switchBtn:GetComponent(UISprite)
  self.switchBtn_Icon = self:FindGO("Icon", self.switchBtn):GetComponent(UISprite)
  self:AddClickEvent(self.switchBtn, function()
    self:ClickSwitchBtn()
  end)
  self.endBtn = self:FindGO("EndBtn")
  self:AddClickEvent(self.endBtn, function()
    if self:IsDoubleActionReadyBuff() then
      ServiceUserEventProxy.Instance:CallDoubleAcionEvent(0, 0)
    end
  end)
end

function BuffTipCell:SetData(data)
  self.data = data
  if data then
    if data.type == "SaveHp" then
      self:SetSaveHp()
      return
    elseif data.type == "SaveSp" then
      self:SetSaveSp()
      return
    end
    if self:IsDoubleActionReadyBuff() then
      self:SetDoubleActionReadyBuff(data)
    else
      self:SetNormalBuff(data)
    end
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.gameObject:SetActive(false)
  end
end

function BuffTipCell:SetNormalBuff(data)
  local staticData = self.data.staticData
  if not staticData then
    local storage = self.data.storage
    if storage then
      for k, v in pairs(storage) do
        staticData = Table_Buffer[v[1]]
        break
      end
    end
  end
  local desc, extend = self:UpdateBuffTip(self.data)
  self.desc.text = desc
  self:SetExtend(extend)
  self.endBtn:SetActive(false)
  self:UpdateSwitchBtn(self.data)
  self:ResizeView()
  self.name.text = ""
  if staticData then
    IconManager:SetSkillIcon(staticData.BuffIcon, self.icon)
    self.icon.width = 20
    if data.isalways then
      TimeTickManager.Me():ClearTick(self, 1)
      self.mask.fillAmount = 0
    elseif data.starttime and data.endtime then
      self:UpdateCDTime()
    elseif data.activeNextDay then
      self.countdown.text = data.active and ZhString.BuffCell_Active or ZhString.BuffCell_ActiveNextDay
    else
      TimeTickManager.Me():ClearTick(self, 1)
      self.mask.fillAmount = 0
    end
    if data.layer and 1 < data.layer and staticData.BuffEffect.type ~= BUFFTYPE_DOUBLEEXPCARD then
      if staticData.BuffEffect.type ~= PerfectServiceBuffType then
        self.layer.text = data.layer
      else
        self.layer.text = data.level
      end
    else
      self.layer.text = ""
    end
  else
    self.gameObject:SetActive(false)
  end
end

function BuffTipCell:SetDoubleActionReadyBuff(data)
  local actionId = Game.Config_DoubleActionBuff[data.staticData.id]
  IconManager:SetActionIcon(Table_ActionAnime[actionId].Name, self.icon)
  local nameCfg = GameConfig.TwinsAction.name_ch
  self.name.text = nameCfg and nameCfg[actionId] or ""
  self.countdown.text = ""
  self.layer.text = ""
  self.desc.text = string.format(ZhString.BuffCell_DoubleAction, data.staticData.BuffDesc)
  self.icon.width = 20
  self:DisplaySwitchBtn(false)
  self.endBtn:SetActive(true)
  TimeTickManager.Me():ClearTick(self, 1)
  self:UpdateDoubleActionLeftTime()
  self:UpdateDoubleActionCDTime()
  self:ResizeView()
end

function BuffTipCell:OnRemove()
  TimeTickManager.Me():ClearTick(self, 1)
end

function BuffTipCell:UpdateCDTime()
  self:_UpdateCDTime(self.UpdateLeftTime)
end

function BuffTipCell:UpdateDoubleActionCDTime()
  self:_UpdateCDTime(self.UpdateDoubleActionLeftTime)
end

function BuffTipCell:_UpdateCDTime(updateCallback)
  if not self.data then
    return
  end
  local starttime, endtime = self.data.starttime, self.data.endtime
  if starttime and endtime then
    local totalDeltaTime = endtime - starttime
    if totalDeltaTime <= 0 then
      self:PassEvent(BuffCellEvent.BuffEnd, self.data)
      return
    end
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 100, function(self, deltaTime)
      local nowDelteTime = math.max(ServerTime.CurServerTime() - starttime, 0)
      local fillAmount = nowDelteTime / totalDeltaTime
      if fillAmount < 1 then
        self.mask.fillAmount = fillAmount
      else
        self:PassEvent(BuffCellEvent.BuffEnd, self.data)
        TimeTickManager.Me():ClearTick(self, 1)
      end
      if updateCallback then
        updateCallback(self)
      end
    end, self, 1)
  end
end

function BuffTipCell:UpdateBuffTip(data)
  if data == nil then
    return "NO DATA"
  end
  if data.storage then
    return MainViewInfoPage.GetStorgeDesc(data.storage)
  end
  local staticData = data.staticData
  if staticData == nil then
    return "No Buff StaticData"
  end
  local desc, text = ItemUtil.GetBuffDesc(staticData.BuffDesc, data.quench)
  if data.fromname and data.fromname ~= "" then
    desc = string.format(desc, data.fromname)
  end
  if data.isRecallBuff then
    local tempArray = {}
    for id, layer in pairs(recall_buffmap) do
      local info = RECALL_BUFF_REWARD_MAP[id]
      table.insert(tempArray, {
        id,
        string.format(info[2], info[1] - layer, info[1])
      })
    end
    table.sort(tempArray, function(a, b)
      return a[1] < b[1]
    end)
    local recall_desc = ""
    for i = 1, #tempArray do
      recall_desc = recall_desc .. tempArray[i][2]
      if i < #tempArray then
        recall_desc = recall_desc .. "\n"
      end
    end
    return desc .. recall_desc
  end
  if data.isEquipBuff and desc ~= "" then
    desc = string.gsub(desc, "%[OffingEquipPoses%]", MainViewInfoPage.GetOffingEquipPoses())
    desc = string.gsub(desc, "%[ProtectEquipPoses%]", MainViewInfoPage.GetProtectEquipPoses())
    desc = string.gsub(desc, "%[BreakEquipPoses%]", MainViewInfoPage.GetBreakEquipPoses())
  end
  local betype, extend = staticData.BuffEffect.type, ""
  if SpecialBuffType[betype] then
    if data.active then
      text = string.format("%s%s\n", staticData.BuffName, ZhString.BuffCell_BuffActive)
    else
      text = string.format("%s%s\n", staticData.BuffName, ZhString.BuffCell_BuffInActive)
    end
    local leftTime = math.ceil(data.layer / 60)
    local colorTip = data.active and "[c][80DF66]" or "[c][FF5F40]"
    local timeTip = 60 < leftTime and ZhString.MainViewInfoPage_Hour or ZhString.MainViewInfoPage_Min
    if 60 < leftTime then
      leftTime = math.ceil(leftTime / 60)
    end
    if staticData.id ~= 1540 then
      if betype == "MultiTime" and ISNoviceServerType then
        extend = string.format("%s%s[-][/c]", colorTip, string.format(ZhString.BuffCell_DELeftTimeTip_Novice, data.layer, ZhString.MainViewInfoPage_Count))
      else
        extend = string.format("%s%s[-][/c]", colorTip, string.format(SpecialBuffType[betype].Desc, leftTime, timeTip))
      end
    end
    text = text .. desc
    self.countdown.text = ""
  else
    if data.isalways then
      return desc
    end
    local curServerTime = ServerTime.CurServerTime() / 1000
    local endtime = data.endtime and data.endtime / 1000
    if endtime then
      if curServerTime > endtime then
        return text
      end
    else
      return desc
    end
  end
  return text or desc, extend
end

function BuffTipCell:UpdateLeftTime()
  local data = self.data
  if not data then
    return
  end
  local staticData = data.staticData
  local betype = staticData.BuffEffect.type
  local text = ""
  if betype == BUFFTYPE_DOUBLEEXPCARD then
    if data.active then
      text = string.format("%s%s\n", staticData.BuffName, ZhString.BuffCell_BuffActive)
    else
      text = string.format("%s%s\n", staticData.BuffName, ZhString.BuffCell_BuffInActive)
    end
    local leftTime = math.ceil(data.layer / 60)
    text = string.format("%ds", leftTime)
    self.countdown.text = text
  else
    if data.isalways then
      self.countdown.text = ""
      TimeTickManager.Me():ClearTick(self, 1)
      return
    end
    local curServerTime = ServerTime.CurServerTime() / 1000
    local endtime = data.endtime and data.endtime / 1000
    if endtime then
      if curServerTime > endtime then
        self.countdown.text = ""
        TimeTickManager.Me():ClearTick(self, 1)
      else
        local day, hour, min, sec = ClientTimeUtil.FormatTimeBySec(math.floor(endtime - curServerTime))
        local leftStr = ""
        if 0 < day then
          leftStr = day .. ZhString.MainViewInfoPage_Day
        elseif 0 < hour then
          leftStr = hour .. ZhString.MainViewInfoPage_Hour
          leftStr = leftStr .. min .. ZhString.MainViewInfoPage_Min
        else
          if 0 < min then
            leftStr = min .. ZhString.MainViewInfoPage_Min
          end
          leftStr = leftStr .. sec .. ZhString.MainViewInfoPage_Sec
        end
        text = leftStr
        self.countdown.text = text
      end
    else
      self.countdown.text = ""
      TimeTickManager.Me():ClearTick(self, 1)
    end
  end
end

function BuffTipCell:UpdateDoubleActionLeftTime()
  local data = self.data
  if not data then
    self:SetExtend()
    return
  end
  local curServerTime = ServerTime.CurServerTime() / 1000
  local endtime = data.endtime and data.endtime / 1000
  if not endtime or curServerTime > endtime then
    TimeTickManager.Me():ClearTick(self, 1)
    return
  end
  local _, _, min, sec = ClientTimeUtil.FormatTimeBySec(math.floor(endtime - curServerTime))
  self:SetExtend(string.format(ZhString.BuffCell_DoubleActionLeftTimeTip, min, sec))
end

function BuffTipCell.GetOffingEquipPoses()
  local offPoses = MyselfProxy.Instance:GetOffingEquipPoses()
  local resultStr = ""
  for i = 1, #offPoses do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(offPoses[i])
    if i < #offPoses then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end

function BuffTipCell.GetProtectEquipPoses()
  local protectPoses = MyselfProxy.Instance:GetProtectEquipPoses()
  local resultStr = ""
  for i = 1, #protectPoses do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(protectPoses[i])
    if i < #protectPoses then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end

function BuffTipCell.GetBreakEquipPoses()
  local breakInfos = BagProxy.Instance.roleEquip:GetBreakEquipSiteInfo()
  local resultStr = ""
  for i = 1, #breakInfos do
    resultStr = resultStr .. RoleEquipBagData.GetSiteNameZh(breakInfos[i].index)
    if i < #breakInfos then
      resultStr = resultStr .. ZhString.MainViewInfoPage_DunHao
    end
  end
  return resultStr
end

function BuffTipCell.GetStorgeDesc(storage)
  local desc = ""
  if storage[1] then
    local desc1 = Table_Buffer[storage[1][1]].BuffDesc
    desc1 = string.gsub(desc1, "%[HPStorage%]", storage[1][2] or 0)
    if desc ~= "" then
      desc = desc .. "\n"
    end
    desc = desc .. desc1
  end
  if storage[2] then
    local desc2 = Table_Buffer[storage[2][1]].BuffDesc
    desc2 = string.gsub(desc2, "%[SPStorage%]", storage[2][2] or 0)
    if desc ~= "" then
      desc = desc .. "\n"
    end
    desc = desc .. desc2
  end
  return desc
end

function BuffTipCell.GetHPStorage(data)
  return data.storage or 0
end

function BuffTipCell.GetSPStorage(data)
  return data.storage or 0
end

function BuffTipCell:DestroySelf()
  if not self:ObjIsNil(self.gameObject) then
    GameObject.Destroy(self.gameObject)
  end
end

function BuffTipCell:ResizeView()
  local descHeight = self.desc.height
  local extendHeight = StringUtil.IsEmpty(self.extend.text) and 0 or self.extend.height + 3
  self.widgetContainer.height = 38 + descHeight + extendHeight
  self.Sprite.transform.localPosition = LuaGeometry.GetTempVector3(0, -descHeight - extendHeight - 6)
end

function BuffTipCell:GetHeight()
  return self.widgetContainer.height
end

function BuffTipCell:SetExtend(extend)
  local empty = StringUtil.IsEmpty(extend)
  self.extend.gameObject:SetActive(not empty)
  if not empty then
    self.extend.text = extend
  end
end

function BuffTipCell:UpdateSwitchBtn(data)
  local staticData = data.staticData
  if not staticData then
    self:DisplaySwitchBtn(false)
    return
  end
  local betype = data.staticData.BuffEffect.type
  if betype == BUFFTYPE_DOUBLEEXPCARD then
    local multiExpSetting = Game.Myself.data.userdata:Get(UDEnum.CHAIN_ACTIVE)
    local value = multiExpSetting == 1 and true or false
    self:DisplaySwitchBtn(true, value)
  else
    self:DisplaySwitchBtn(false)
  end
end

function BuffTipCell:DisplaySwitchBtn(display, active)
  self.switchBtn:SetActive(display)
  if display then
    if active then
      self.switchBtn_BGSprite.spriteName = "new-com_btn_circle-s"
      self.switchBtn_Icon.spriteName = "taskmanual_icon_suspend"
      self.switchBtn_Icon.color = ColorUtil.NGUIWhite
    else
      self.switchBtn_BGSprite.spriteName = "new-com_btn_circle-s_2"
      self.switchBtn_Icon.spriteName = "taskmanual_icon_play"
      self.switchBtn_Icon.color = LuaGeometry.GetTempColor(0.403921568627451, 0.42745098039215684, 0.5607843137254902)
    end
  end
end

function BuffTipCell:ClickSwitchBtn()
  if self.data.type == "SaveHp" then
    self:SwitchSaveHp()
  elseif self.data.type == "SaveSp" then
    self:SwitchSaveSp()
  elseif self.data.staticData.BuffEffect.type == BUFFTYPE_DOUBLEEXPCARD then
    local multiExpSetting = Game.Myself.data.userdata:Get(UDEnum.CHAIN_ACTIVE)
    local value = multiExpSetting == 1 and true or false
    ServiceNUserProxy.Instance:CallChainOptUserCmd(not value)
  end
end

function BuffTipCell:IsDoubleActionReadyBuff()
  local sData = self.data and self.data.staticData
  return sData and Game.Config_DoubleActionBuff[sData.id] and true or false
end

function BuffTipCell:SwitchSaveHp()
  local opt = Game.Myself.data.userdata:Get(UDEnum.OPTION) or 0
  local userDataActive = 0 < BitUtil.band(opt, SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP)
  if self.saveHpActive == userDataActive then
    self.saveHpActive = not self.saveHpActive
    ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP, self.saveHpActive and 1 or 0)
  end
end

function BuffTipCell:SwitchSaveSp()
  local opt = Game.Myself.data.userdata:Get(UDEnum.OPTION) or 0
  local userDataActive = 0 < BitUtil.band(opt, SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP)
  if self.saveSpActive == userDataActive then
    self.saveSpActive = not self.saveSpActive
    ServiceNUserProxy.Instance:CallNewSetOptionUserCmd(SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP, self.saveSpActive and 1 or 0)
  end
end

function BuffTipCell:SetSaveHp()
  IconManager:SetSkillIcon("itembuff_12354", self.icon)
  local opt = Game.Myself.data.userdata:Get(UDEnum.OPTION) or 0
  self.saveHpActive = 0 < BitUtil.band(opt, SceneUser2_pb.EOPTIONTYPE_USE_SAVE_HP)
  self:DisplaySwitchBtn(true, self.saveHpActive)
  local desc = ZhString.BuffTipCell_HPEnergy .. (self.saveHpActive and ZhString.BuffCell_BuffActive or ZhString.BuffCell_BuffInActive)
  desc = desc .. "\n" .. ZhString.BuffTipCell_HPEnergyDes
  self.desc.text = desc
  local colorTip = self.saveHpActive and "[c][80DF66]" or "[c][FF5F40]"
  local saveHp = Game.Myself.data.props:GetPropByName("SaveHp")
  local extend = string.format(ZhString.BuffTipCell_LeftHpEnergy, saveHp and saveHp.value or 0)
  extend = colorTip .. extend .. "[-][c]"
  self:SetExtend(extend)
  self:ResizeView()
end

function BuffTipCell:SetSaveSp()
  IconManager:SetSkillIcon("itembuff_12354", self.icon)
  local opt = Game.Myself.data.userdata:Get(UDEnum.OPTION) or 0
  self.saveSpActive = 0 < BitUtil.band(opt, SceneUser2_pb.EOPTIONTYPE_USE_SAVE_SP)
  self:DisplaySwitchBtn(true, self.saveSpActive)
  local desc = ZhString.BuffTipCell_SPEnergy .. (self.saveSpActive and ZhString.BuffCell_BuffActive or ZhString.BuffCell_BuffInActive)
  desc = desc .. "\n" .. ZhString.BuffTipCell_SPEnergyDes
  self.desc.text = desc
  local colorTip = self.saveSpActive and "[c][80DF66]" or "[c][FF5F40]"
  local saveSp = Game.Myself.data.props:GetPropByName("SaveSp")
  local extend = string.format(ZhString.BuffTipCell_LeftSpEnergy, saveSp and saveSp.value or 0)
  extend = colorTip .. extend .. "[-][c]"
  self:SetExtend(extend)
  self:ResizeView()
end
