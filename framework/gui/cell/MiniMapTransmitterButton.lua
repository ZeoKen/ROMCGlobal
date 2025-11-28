MiniMapTransmitterButton = class("MiniMapTransmitterButton", BaseCell)
MiniMapTransmitterButton.E_State = {
  Activated = 0,
  Unactivated = 1,
  Disable = 2
}
local IsRunOnEditor = ApplicationInfo.IsRunOnEditor()

function MiniMapTransmitterButton:Init()
  self.sprIcon = self:FindComponent("Icon", UISprite)
  self.objSelect = self:FindGO("HighLight")
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self:AddCellClickEvent()
end

function MiniMapTransmitterButton:SetData(data, isForbidUse)
  self.data = data
  self.id = data.staticdata.id
  if IsRunOnEditor then
    self.gameObject.name = string.format("MiniMapTransmitterButton_%s", tostring(id))
  end
  self.isMain = data.staticdata.NpcType == 0
  self.isCurrent = data.isCurrent
  self.state = data.state
  self.npcName = Table_Npc[data.staticdata.NpcID].NameZh
  local config = GameConfig.Transmitter[data.staticdata.MapGroup]
  if config then
    IconManager:SetMapIcon(self.isMain and config.IconBig or config.IconSmall, self.sprIcon)
  end
  if self.state == MiniMapTransmitterButton.E_State.Unactivated then
    self:SetTextureGrey(self.sprIcon)
    self.boxCollider.enabled = false
  else
    self:SetTextureWhite(self.sprIcon)
    self.boxCollider.enabled = not isForbidUse or isForbidUse ~= true
  end
  local isSmallWindowAndUnactivated = self.state == MiniMapTransmitterButton.E_State.Unactivated and isForbidUse and isForbidUse == true
  self:PlayUnactivatedEffect(isSmallWindowAndUnactivated)
end

function MiniMapTransmitterButton:Select(isSelect)
  self.objSelect:SetActive(isSelect)
end

function MiniMapTransmitterButton:SetForbidUse(isForbidUse)
  if self.state == MiniMapTransmitterButton.E_State.Unactivated then
    self.boxCollider.enabled = false
  else
    self.boxCollider.enabled = not isForbidUse or isForbidUse ~= true
  end
end

local symbolHintScale = 0.15

function MiniMapTransmitterButton:PlayUnactivatedEffect(isPlay)
  if self.last_isPlay ~= nil and self.last_isPlay == isPlay then
    return
  end
  self.last_isPlay = isPlay
  if isPlay then
    if not self.unactivatedEffect then
      self:PlayUIEffect(EffectMap.UI.MapTransmitterButton, self.gameObject, false, function(obj, args, assetEffect)
        self.unactivatedEffect = assetEffect
      end, nil, symbolHintScale)
    end
  elseif self.unactivatedEffect then
    self.unactivatedEffect:Destroy()
    self.unactivatedEffect = nil
  end
end
