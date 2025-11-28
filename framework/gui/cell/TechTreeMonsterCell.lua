autoImport("TechTreeBuildingCell")
local baseCell = autoImport("BaseCell")
TechTreeMonsterCell = class("TechTreeMonsterCell", baseCell)
local monsterLockColor, tempV3, tickManager = LuaColor.New(0.14901960784313725, 0.16862745098039217, 0.26666666666666666, 0.6), LuaVector3.New()

function TechTreeMonsterCell:Init()
  if not tickManager then
    tickManager = TimeTickManager.Me()
  end
  self.title = self:FindComponent("Title", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.level = self:FindComponent("Level", UILabel)
  self.chooseWidget = self:FindComponent("Choose", UIWidget)
  self.lock = self:FindGO("Lock")
  self.notSummoned = self:FindGO("NotSummoned")
  self.time = self:FindGO("Time")
  self.timeLabel = self:FindComponent("TimeLabel", UILabel)
  self.gotoBtn = self:FindGO("GotoBtn")
  self:AddCellClickEvent()
  self:AddClickEvent(self.gotoBtn, function()
    local data = self.eliteData
    FunctionMonster.Me():GotoRareEliteMonster(self.data.id, data and data.posX / 1000, data and data.posY / 1000, data and data.posZ / 1000)
    GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
  end)
end

function TechTreeMonsterCell:SetData(data)
  local flag = data ~= nil
  self.data = data
  self.gameObject:SetActive(flag)
  if flag then
    local isUnlock, id = self:GetUnlock(), data.id
    local mData = Table_Monster[id]
    self.title.text = isUnlock and mData.NameZh or "????????"
    IconManager:SetFaceIcon(mData.Icon, self.icon)
    self.icon.color = isUnlock and ColorUtil.NGUIWhite or monsterLockColor
    self.level.text = isUnlock and string.format("Lv.%d", mData.Level) or ""
    self.lock:SetActive(not isUnlock)
    self.gotoBtn:SetActive(isUnlock and data.MapID ~= nil)
    if not isUnlock then
      self.notSummoned:SetActive(false)
      self.time:SetActive(false)
    end
  end
  self:UpdateChoose()
end

function TechTreeMonsterCell:UpdateElite(d)
  if self.lock.activeSelf then
    return
  end
  self.eliteData = type(d) == "table" and d or nil
  local status = self.eliteData and self.eliteData.status
  if not status then
    return
  end
  self.notSummoned:SetActive(status == ERAREELITESTATUS.ERAREELITESTATUS_UNKNOWN)
  self.gotoBtn:SetActive(status == ERAREELITESTATUS.ERAREELITESTATUS_ALIVE)
  local isDead = status == ERAREELITESTATUS.ERAREELITESTATUS_DEAD
  self.time:SetActive(isDead)
  if isDead then
    self.endTime = self.eliteData.leftTime + ServerTime.CurServerTime() / 1000
    if self.endTime and self.endTime > 0 then
      self:ClearTick()
      self.timeTick = tickManager:CreateTick(0, 33, self.UpdateDuration, self, 1)
    end
  end
end

function TechTreeMonsterCell:OnCellDestroy()
  self:ClearTick()
end

function TechTreeMonsterCell:SetChooseId(id)
  TechTreeBuildingCell.SetChooseId(self, id)
end

function TechTreeMonsterCell:UpdateChoose()
  TechTreeBuildingCell.UpdateChoose(self)
end

function TechTreeMonsterCell:GetUnlock()
  return TechTreeBuildingCell.GetUnlock(self)
end

function TechTreeMonsterCell:ClearTick()
  if self.timeTick ~= nil then
    tickManager:ClearTick(self)
    self.timeTick = nil
  end
end

function TechTreeMonsterCell:UpdateDuration()
  if self.endTime then
    local leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
    self.timeLabel.text = string.format("%02d:%02d", math.ceil(leftTime) / 60, math.ceil(leftTime) % 60)
    if leftTime <= 0 then
      self.endTime = nil
    end
  else
    self:ClearTick()
    TechTreeProxy.CallMapRareElite()
  end
end
