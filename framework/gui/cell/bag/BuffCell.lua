local BaseCell = autoImport("BaseCell")
BuffCell = class("BuffCell", BaseCell)
BuffCellEvent = {
  BuffEnd = "BuffCellEvent_BuffEnd"
}
local SpecialBuffType = {
  MultiTime = {Desc = ""},
  MultiExp = {Desc = ""},
  MultiItem = {Desc = ""}
}
local EmptyBuffID = "EmptyBuff"
local doubleActionBuffCfg
local PerfectServiceBuffType = "PerfectService"

function BuffCell:Init()
  self.mask = self:FindComponent("Mask", UISprite)
  self.icon = self:FindComponent("Icon", UISprite)
  self.layer = self:FindComponent("Layer", UILabel)
  self.stop = self:FindGO("Stop")
  self.moreContainer = self:FindGO("MoreContainer")
  self.buffContainer = self:FindGO("BuffContainer")
  self:AddCellClickEvent()
end

function BuffCell:SetData(data)
  self.data = data
  if data then
    local staticData = self.data.staticData
    if self.data.id == EmptyBuffID then
      if self.moreContainer then
        self.moreContainer:SetActive(true)
      end
      if self.buffContainer then
        self.buffContainer:SetActive(false)
      end
    else
      if self.buffContainer then
        self.buffContainer:SetActive(true)
      end
      if self.moreContainer then
        self.moreContainer:SetActive(false)
      end
      if staticData == nil then
        local storage = self.data.storage
        if storage ~= nil then
          for k, v in pairs(storage) do
            staticData = Table_Buffer[v[1]]
            break
          end
        end
      end
      if staticData then
        if self:IsDoubleActionReadyBuff() then
          IconManager:SetActionIcon(Table_ActionAnime[self:GetDoubleActionIdFromBuff()].Name, self.icon)
        else
          IconManager:SetSkillIcon(staticData.BuffIcon, self.icon)
        end
        self.icon.width = 28
        if data.isalways then
          TimeTickManager.Me():ClearTick(self, 1)
          self.mask.fillAmount = 0
        elseif data.starttime and data.endtime then
          self:UpdateCDTime()
        else
          TimeTickManager.Me():ClearTick(self, 1)
          self.mask.fillAmount = 0
        end
        if not self:ObjIsNil(self.layer) then
          if data.layer and 1 < data.layer and not self:HideBuffLayer(staticData.BuffEffect.type) then
            if staticData.BuffEffect.type ~= PerfectServiceBuffType then
              self.layer.text = data.layer
            else
              self.layer.text = data.level
            end
          else
            self.layer.text = ""
          end
        else
        end
        if self.stop then
          if SpecialBuffType[staticData.BuffEffect.type] then
            self.stop:SetActive(not data.active)
          else
            self.stop:SetActive(false)
          end
        end
      else
        self.gameObject:SetActive(false)
      end
    end
  else
    TimeTickManager.Me():ClearTick(self, 1)
    self.gameObject:SetActive(false)
  end
end

function BuffCell:OnRemove()
  TimeTickManager.Me():ClearTick(self, 1)
  TipManager.Instance:CloseNormalTip()
end

function BuffCell:UpdateCDTime(timetick)
  if not self.data then
    return
  end
  local starttime, endtime = self.data.starttime, self.data.endtime
  if starttime and endtime then
    local totalDeltaTime = endtime - starttime
    if totalDeltaTime <= 0 then
      FunctionBuff.Me():TryRemoveMyBuff(self.data.id)
      return
    end
    TimeTickManager.Me():ClearTick(self, 1)
    TimeTickManager.Me():CreateTick(0, 33, function(self, deltatime)
      local nowDelteTime = math.max(ServerTime.CurServerTime() - starttime, 0)
      local fillAmount = nowDelteTime / totalDeltaTime
      if fillAmount < 1 then
        self.mask.fillAmount = fillAmount
      else
        FunctionBuff.Me():TryRemoveMyBuff(self.data.id)
        TimeTickManager.Me():ClearTick(self, 1)
      end
    end, self, 1)
  end
end

function BuffCell:HideBuffLayer(bufftype)
  if bufftype and SpecialBuffType[bufftype] then
    return true
  else
    return false
  end
end

function BuffCell:IsDoubleActionReadyBuff()
  return self:GetDoubleActionIdFromBuff() and true or false
end

function BuffCell:GetDoubleActionIdFromBuff()
  if not doubleActionBuffCfg then
    doubleActionBuffCfg = Game.Config_DoubleActionBuff
  end
  local sData = self.data and self.data.staticData
  return sData and doubleActionBuffCfg[sData.id]
end
