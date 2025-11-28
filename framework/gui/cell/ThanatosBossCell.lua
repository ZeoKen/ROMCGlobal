local baseCell = autoImport("BaseCell")
ThanatosBossCell = class("ThanatosBossCell", baseCell)

function ThanatosBossCell:Init()
  self:FindObjs()
  self:AddButtonEvt()
end

function ThanatosBossCell:FindObjs()
  self.statusSp = self.gameObject:GetComponent(UIMultiSprite)
  self.lock = self:FindGO("lock")
  self.bossIcon = self:FindGO("bossIcon"):GetComponent(UISprite)
  self.statusLabel = self:FindGO("statusLabel"):GetComponent(UILabel)
  self.chooseSymbol = self:FindGO("chooseSymbol"):GetComponent(UIMultiSprite)
  self.tog = self.gameObject:GetComponent(UIToggle)
  self.effectContainer = self:FindGO("effectContainer")
  self.isLoad = false
  self.chooseSymbol.CurrentState = 0
end

function ThanatosBossCell:AddButtonEvt()
  self:AddClickEvent(self.gameObject, function()
    self:Query()
  end)
  self:SetEvent(self.gameObject, function()
    self:SetTog(true)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function ThanatosBossCell:UpdateChoose()
  if not self.data then
    return
  end
  if self.data.npcid == self.chooseNpcId then
    self.chooseSymbol.CurrentState = 1
    self.statusSp.CurrentState = 1
    if not self.isLoad then
      self:PlayUIEffect(EffectMap.UI.Eff_boss_frame_ui, self.effectContainer)
      self.isLoad = true
    end
    self.effectContainer.gameObject:SetActive(true)
    self.statusLabel.fontSize = 22
  else
    self.chooseSymbol.CurrentState = 0
    self.statusSp.CurrentState = 0
    self.effectContainer.gameObject:SetActive(false)
    self.statusLabel.fontSize = 18
  end
  self.chooseSymbol:MakePixelPerfect()
end

function ThanatosBossCell:SetChoose(id)
  self.chooseNpcId = id
  self:UpdateChoose()
end

function ThanatosBossCell:SetTog(v)
  self.tog.value = v
end

local TimeFormat = "%Y.%m.%d"

function ThanatosBossCell:SetData(data)
  self.data = data
  if data then
    self.data = data
    local mData = Table_Monster[data.npcid]
    if mData then
      IconManager:SetFaceIcon(mData.Icon, self.bossIcon)
      self.bossIcon.gameObject:SetActive(true)
    else
      self.bossIcon.gameObject:SetActive(false)
    end
    if not data.isCleared then
      self.statusLabel.text = ZhString.ThanatosMonument_Unlock
    elseif self.data.time then
      self.statusLabel.text = os.date(TimeFormat, self.data.time)
    end
    self:UpdateChoose()
  end
end
