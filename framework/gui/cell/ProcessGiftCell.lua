local baseCell = autoImport("BaseCell")
ProcessGiftCell = class("ProcessGiftCell", BaseCell)

function ProcessGiftCell:Init()
  self:FindObjs()
  self:AddEvts()
end

function ProcessGiftCell:FindObjs()
  self.gift = self:FindGO("GiftIcon")
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self.finishStatus = self:FindGO("FinishStatus")
  self.effectContainer = self:FindGO("EffectContainer")
  self.effectContainer:SetActive(false)
  self.containerRq = self:FindComponent("EffectContainer", ChangeRqByTex)
end

function ProcessGiftCell:AddEvts()
  self:SetEvent(self.gift, function()
    redlog("点击")
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddCellClickEvent()
end

function ProcessGiftCell:InitShow(k, totalWidth)
  local perCent = k / 100
  local tempX = perCent * totalWidth
  self.trans.localPosition = LuaGeometry.GetTempVector3(tempX, 0, 0)
  self.giftProcess = k
end

function ProcessGiftCell:InitStatus(status, score)
  if status == 1 then
    self.gift:SetActive(true)
    self.finishStatus:SetActive(false)
    if score >= self.giftProcess then
      if not self.effect then
        self.effect = self:PlayUIEffect(EffectMap.UI.Bazaar_chest, self.effectContainer)
      end
      self.effectContainer:SetActive(true)
      self.containerRq.excute = true
    end
  else
    self.finishStatus:SetActive(true)
    self.gift:SetActive(false)
  end
end

function ProcessGiftCell:RewardEffectHandle(effectHandle, owner)
  if effectHandle and not LuaGameObject.ObjectIsNull(effectHandle.gameObject) then
    self.containerRq:AddChild(effectHandle.gameObject)
  end
end
