local baseCell = autoImport("BaseCell")
SkillBaseCell = class("SkillBaseCell", baseCell)

function SkillBaseCell:TryFindObjs()
  self.expireTime = self:FindGO("ExpireTime")
  if self.expireTime ~= nil then
    self.expireTime = self.expireTime:GetComponent(UILabel)
  end
  self.usedCount = self:FindGO("UsedCount")
  if self.usedCount ~= nil then
    self.usedCount = self.usedCount:GetComponent(UILabel)
  end
end

function SkillBaseCell:UpdateExpireTime()
  if self.expireTime ~= nil then
    local data = self.data
    local _FunctionCDCommand = FunctionCDCommand.Me()
    local cdCtrl = _FunctionCDCommand:GetCDProxy(SkillCountdownRefresher)
    if data ~= nil and data.expireTime ~= nil and data.expireTime > ServerTime.CurServerTime() / 1000 then
      self:Show(self.expireTime.gameObject)
      if cdCtrl == nil then
        cdCtrl = _FunctionCDCommand:StartCDProxy(SkillCountdownRefresher, 1000)
      end
      cdCtrl:Add(self)
    else
      self:Hide(self.expireTime.gameObject)
      self:ClearCountdown()
    end
  end
end

function SkillBaseCell:ClearCountdown()
  local cdCtrl = FunctionCDCommand.Me():GetCDProxy(SkillCountdownRefresher)
  if cdCtrl ~= nil then
    cdCtrl:Remove(self)
  end
end

function SkillBaseCell:SetExpireTime()
  local time = self.data.expireTime - ServerTime.CurServerTime() / 1000
  if 0 < time then
    self.expireTime.text = string.format("%02d:%02d", ClientTimeUtil.GetFormatSecTimeStr(time))
    return false
  else
    self:Hide(self.expireTime.gameObject)
  end
  return true
end

function SkillBaseCell:UpdateUsedCount()
  if self.usedCount ~= nil then
    local data = self.data
    if data ~= nil and data.allCount ~= nil and data.allCount > 0 then
      self:Show(self.usedCount.gameObject)
      self.usedCount.text = string.format("%d/%d", data.usedCount, data.allCount)
    else
      self:Hide(self.usedCount.gameObject)
    end
  end
end

function SkillBaseCell:OnRemove()
  self:ClearCountdown()
end
