local BaseCell = autoImport("BaseCell")
GvGPvpAttrCell = class("GvGPvpAttrCell", BaseCell)

function GvGPvpAttrCell:Init()
  self.name = self:FindComponent("nameLab", UILabel)
  self.attr = self:FindComponent("attrLab", UILabel)
  self.bg = self:FindComponent("bg", UISprite)
  self.bgline = self:FindComponent("bgline", UISprite)
end

function GvGPvpAttrCell:SetData(data)
  if data then
    self.name.text = data[1]
    self.attr.text = string.format("+%s", data[2])
    local t = data[3]
    if t and 0 < t then
      local colorID = GameConfig.GvGPvP_PrayType and GameConfig.GvGPvP_PrayType[t] and GameConfig.GvGPvP_PrayType[t].colorID
      colorID = colorID or data[4]
      self:SetColor(colorID)
    end
  end
end

function GvGPvpAttrCell:SetColor(id)
  if not id then
    return
  end
  local colorCfg = Table_GFaithUIColorConfig[id]
  if colorCfg then
    local _, rc = ColorUtil.TryParseHexString(colorCfg.bg_Color)
    if _ then
      self.bg.color = rc
    end
    _, rc = ColorUtil.TryParseHexString(colorCfg.bgline_Color)
    if _ then
      self.bgline.color = rc
    end
  end
end
