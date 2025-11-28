MapTransmitterButton = class("MapTransmitterButton", BaseCell)
MapTransmitterButton.E_State = {
  Activated = 0,
  Unactivated = 1,
  Disable = 2
}

function MapTransmitterButton:Init()
  self.sprIcon = self:FindComponent("Icon", UISprite)
  self.objSelect = self:FindGO("HighLight")
  self:AddCellClickEvent()
end

function MapTransmitterButton:SetData(data)
  self.data = data
  self.id = data.staticdata.id
  self.isMain = data.staticdata.NpcType == 0
  self.isCurrent = data.isCurrent
  self.state = data.state
  self.npcName = Table_Npc[data.staticdata.NpcID].NameZh
  local config = GameConfig.Transmitter[data.staticdata.MapGroup]
  if config then
    IconManager:SetMapIcon(self.isMain and config.IconBig or config.IconSmall, self.sprIcon)
  end
  if self.state == MapTransmitterButton.E_State.Unactivated then
    self:SetTextureGrey(self.sprIcon)
  else
    self:SetTextureWhite(self.sprIcon)
  end
end

function MapTransmitterButton:Select(isSelect)
  self.objSelect:SetActive(isSelect)
end
