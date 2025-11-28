local BaseCell = autoImport("BaseCell")
WildMvpBuffCell = class("WildMvpBuffCell", BaseCell)

function WildMvpBuffCell:Init()
  self:FindObjs()
  self:AddGameObjectComp()
end

function WildMvpBuffCell:FindObjs()
  self.countLimitGO = self:FindGO("CountLimit")
  self.countLimitTable = self:FindComponent("Table", UITable, self.countLimitGO)
  self.countLimitLab1 = self:FindComponent("Lab1", UILabel, self.countLimitGO)
  self.countLimitLab2 = self:FindComponent("Lab2", UILabel, self.countLimitGO)
  self.countLimitLab2GO = self.countLimitLab2.gameObject
  self.timeLimitGO = self:FindGO("TimeLimit")
  self.timeLimitTable = self:FindComponent("Table", UITable, self.timeLimitGO)
  self.timeLimitLab1 = self:FindComponent("Lab1", UILabel, self.timeLimitGO)
  self.timeLimitLab2 = self:FindComponent("Lab2", UILabel, self.timeLimitGO)
  self.timeLimitLab2GO = self.timeLimitLab2.gameObject
  local contentGO = self:FindGO("ContentTable")
  self.contentTable = contentGO:GetComponent("UITable")
  self.descLab = self:FindComponent("DescLabel", UILabel, contentGO)
  self.countGO = self:FindGO("CountBG", contentGO)
  self.countLab = self:FindComponent("CountLabel", UILabel, self.countGO)
  self.qualityIcon = self:FindComponent("QualityIcon", UISprite)
  self.newIconGO = self:FindGO("NewIcon")
  self.upIconGO = self:FindGO("UpIcon", contentGO)
  self.downIconGO = self:FindGO("DownIcon", contentGO)
end

function WildMvpBuffCell:SetData(data)
  self.data = data
  self:UpdateContent()
  local limitType = self.data:GetLimitType()
  if limitType == WildMvpBuffData.LimitType.TimeLimit then
    self.timeLimitGO:SetActive(true)
    self.countLimitGO:SetActive(false)
    if self.gameObject.activeInHierarchy then
      self:StopTimer()
      self:StartTimer()
    end
  elseif limitType == WildMvpBuffData.LimitType.CountLimit then
    self.timeLimitGO:SetActive(false)
    self.countLimitGO:SetActive(true)
    self:UpdateCountLimit()
  else
    self.timeLimitGO:SetActive(false)
    self.countLimitGO:SetActive(false)
  end
  self.newIconGO:SetActive(data:IsNew())
  self.upIconGO:SetActive(data:IsAccUp())
  self.downIconGO:SetActive(data:IsAccDown())
end

function WildMvpBuffCell:UpdateContent()
  self.descLab.text = self.data:GetDescStr()
  local curAccCount = self.data:GetAccCount()
  if curAccCount and 0 < curAccCount then
    self.countGO:SetActive(true)
    self.countLab.text = string.format(ZhString.WildMvpBuffAccCount, curAccCount)
  else
    self.countGO:SetActive(false)
  end
  local accDesc = self.data:GetAccDesc()
  self.timeLimitLab1.text = accDesc
  self.countLimitLab1.text = accDesc
  self.contentTable:Reposition()
  local qualityColor = self.data:GetQualityColor()
  if qualityColor and self.qualityIcon then
    self.qualityIcon.color = qualityColor
  end
end

function WildMvpBuffCell:UpdateTimerLimit()
  local timeLeft = self.data:GetTimeLeft()
  if timeLeft and 0 < timeLeft then
    if self.isTimeLimitEnabled ~= true then
      self.timeLimitLab2GO:SetActive(true)
      self.isTimeLimitEnabled = true
      self.timeLimitTable:Reposition()
    end
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(timeLeft)
    self.timeLimitLab2.text = string.format("%02d:%02d", min, sec)
    return true
  else
    if timeLeft and timeLeft <= 0 then
      WildMvpProxy.Instance:ScheduleQueryBuffs()
    end
    if self.isTimeLimitEnabled ~= false then
      self.timeLimitLab2GO:SetActive(false)
      self.isTimeLimitEnabled = false
      self.timeLimitTable:Reposition()
    end
    return false
  end
end

function WildMvpBuffCell:UpdateCountLimit()
  local leftCount = self.data:GetLeftCount()
  if leftCount and 0 < leftCount then
    self.countLimitLab2GO:SetActive(true)
    self.countLimitLab2.text = "x" .. leftCount
  else
    self.countLimitLab2GO:SetActive(false)
  end
  self.countLimitTable:Reposition()
end

function WildMvpBuffCell:OnEnable()
  self:StartTimer()
end

function WildMvpBuffCell:OnDisable()
  self:StopTimer()
end

function WildMvpBuffCell:OnDestroy()
  self:StopTimer()
end

function WildMvpBuffCell:OnCellDestroy()
  self:StopTimer()
end

function WildMvpBuffCell:StartTimer()
  if self.timer then
    return
  end
  if self:UpdateTimerLimit() then
    self.timer = TimeTickManager.Me():CreateTick(0, 1000, function()
      if not self:UpdateTimerLimit() then
        self:StopTimer()
      end
    end, self)
  end
end

function WildMvpBuffCell:StopTimer()
  if self.timer then
    self.timer:Destroy()
    self.timer = nil
  end
end

function WildMvpBuffCell:OnCollapsed(b)
  if not b then
    self.contentTable:Reposition()
    self.timeLimitTable:Reposition()
    self.countLimitTable:Reposition()
  end
end
