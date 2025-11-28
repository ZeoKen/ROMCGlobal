local BaseCell = autoImport("BaseCell")
WildMvpMonsterCell = class("WildMvpMonsterCell", BaseCell)
local monsterLockColor = LuaColor.New(0.14901960784313725, 0.16862745098039217, 0.26666666666666666, 0.6)
local tempV3 = LuaVector3.New()

function WildMvpMonsterCell:Init()
  self.title = self:FindComponent("Title", UILabel)
  self.icon = self:FindComponent("Icon", UISprite)
  self.level = self:FindComponent("Level", UILabel)
  self.chooseWidget = self:FindComponent("Choose", UIWidget)
  self.lock = self:FindGO("Lock")
  self.notSummoned = self:FindGO("NotSummoned")
  self.time = self:FindGO("Time")
  self.timeLabel = self:FindComponent("TimeLabel", UILabel)
  self.gotoBtn = self:FindGO("GotoBtn")
  self:AddGameObjectComp()
  self:AddCellClickEvent()
  self:AddClickEvent(self.gotoBtn, function()
    local x, y, z = self.data:GetElitePositionXYZ()
    if x and y and z then
      FunctionMonster.Me():GotoRareEliteMonster(self.data.id, x, y, z)
      GameFacade.Instance:sendNotification(UIEvent.CloseUI, UIViewType.NormalLayer)
    end
  end)
  self:SetEvent(self.icon.gameObject, function()
    self:PassEvent(UICellEvent.OnMidBtnClicked, self)
  end)
end

function WildMvpMonsterCell:SetData(data)
  self.data = data
  self:StopTimer()
  if data then
    local isUnlock = true
    local mData = data:GetStaticMonsterData()
    self.title.text = isUnlock and mData.NameZh or "????????"
    IconManager:SetFaceIcon(mData.Icon, self.icon)
    self.icon.color = isUnlock and ColorUtil.NGUIWhite or monsterLockColor
    self.level.text = isUnlock and string.format("Lv.%d", mData.Level) or ""
    self.lock:SetActive(not isUnlock)
    self:UpdateState()
  end
end

function WildMvpMonsterCell:UpdateState()
  if not self.data then
    return
  end
  self.notSummoned:SetActive(not self.data:IsSummoned())
  self.gotoBtn:SetActive(self.data:IsAlive() and self.data:GetMapID() ~= nil)
  local isDead = self.data:IsDead()
  self.time:SetActive(isDead)
  if isDead and self.gameObject.activeInHierarchy then
    self:StartTimer()
  end
end

function WildMvpMonsterCell:SetSelected(b)
  if b then
    self.chooseWidget.gameObject:SetActive(true)
  else
    self.chooseWidget.gameObject:SetActive(false)
  end
end

function WildMvpMonsterCell:OnEnable()
  self:StartTimer()
end

function WildMvpMonsterCell:OnDisable()
  self:StopTimer()
end

function WildMvpMonsterCell:OnDestroy()
  self:StopTimer()
end

function WildMvpMonsterCell:OnCellDestroy()
  self:StopTimer()
end

function WildMvpMonsterCell:StartTimer()
  if self.timer then
    return
  end
  if self:UpdateTimeLabel() then
    self.timer = TimeTickManager.Me():CreateTick(0, 1000, function()
      if not self:UpdateTimeLabel() then
        self:StopTimer()
      end
    end, self)
  end
end

function WildMvpMonsterCell:UpdateTimeLabel()
  local timeLeft = self.data:GetTimeLeft()
  if timeLeft and 0 < timeLeft then
    self.time:SetActive(true)
    local min, sec = ClientTimeUtil.GetFormatSecTimeStr(timeLeft)
    self.timeLabel.text = string.format("%02d:%02d", min, sec)
    return true
  else
    if timeLeft and timeLeft <= 0 then
      WildMvpProxy.Instance:ScheduleQueryMapRareElites()
    end
    self.time:SetActive(false)
    return false
  end
end

function WildMvpMonsterCell:StopTimer()
  if self.timer then
    self.timer:Destroy()
    self.timer = nil
  end
end
