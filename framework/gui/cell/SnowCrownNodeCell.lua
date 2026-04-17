autoImport("BaseCell")
SnowCrownNodeCell = class("SnowCrownNodeCell", BaseCell)

function SnowCrownNodeCell:Init()
  SnowCrownNodeCell.super.Init(self)
  self.nodeIcon = self:FindComponent("NodeIcon", UISprite)
  self.nodeBg = self.gameObject:GetComponent(UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self:AddCellClickEvent()
end

function SnowCrownNodeCell:SetData(data)
  SnowCrownNodeCell.super.SetData(self, data)
  self.data = data
  self:RegisterGuide(data)
  if not data or not data.config then
    return
  end
  local mode = data.config.Mode or 1
  local isUnlocked = data.isUnlocked or data.isActivated or false
  if self.nodeBg then
    local bgSpriteName = self:GetBgSpriteName(mode)
    if bgSpriteName then
      self.nodeBg.spriteName = bgSpriteName
    end
    if isUnlocked then
      self.nodeBg.color = ColorUtil.NGUIWhite
    else
      self.nodeBg.color = ColorUtil.NGUIGray
    end
  end
  if self.nodeIcon then
    local iconSpriteName = self:GetIconSpriteName(data.id)
    if iconSpriteName then
      self.nodeIcon.spriteName = iconSpriteName
    end
    if isUnlocked then
      self.nodeIcon.color = ColorUtil.NGUIWhite
    else
      self.nodeIcon.color = ColorUtil.NGUIGray
    end
  end
  self:SetSelected(false)
end

function SnowCrownNodeCell:RegisterGuide(data)
  self:AddOrRemoveGuideId(self.gameObject)
  if data and data.id == 1 then
    self:AddOrRemoveGuideId(self.gameObject, 562)
  end
end

function SnowCrownNodeCell:SetSelected(isSelected)
  if self.chooseSymbol then
    if isSelected then
      self:Show(self.chooseSymbol)
    else
      self:Hide(self.chooseSymbol)
    end
  end
end

function SnowCrownNodeCell:GetBgSpriteName(mode)
  if mode == SnowCrownProxy.ModeEnum.Atk then
    return "snowflake_icon_red"
  elseif mode == SnowCrownProxy.ModeEnum.Def then
    return "snowflake_icon_bule"
  elseif mode == SnowCrownProxy.ModeEnum.Ele then
    return "snowflake_icon_yellow"
  end
  return "snowflake_icon_red"
end

function SnowCrownNodeCell:GetIconSpriteName(nodeId)
  if not nodeId then
    return nil
  end
  local config = Table_SnowMode[nodeId]
  if config and config.Icon then
    return config.Icon
  end
  return nil
end
