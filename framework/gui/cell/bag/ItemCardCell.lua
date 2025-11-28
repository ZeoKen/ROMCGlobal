local BaseCell = autoImport("BaseCell")
ItemCardCell = class("ItemCardCell", BaseCell)
CardUIConfig_Quality = {
  [1] = {bgColor = "dbdbdb", cardQualityColor = "bac6cf"},
  [2] = {bgColor = "e0edc3", cardQualityColor = "cef874"},
  [3] = {bgColor = "e5ecf3", cardQualityColor = "9be9ff"},
  [4] = {bgColor = "e8e3f7", cardQualityColor = "d0a7ff"},
  [5] = {bgColor = "ffe898", cardQualityColor = "ffda61"}
}

function ItemCardCell:ctor(go)
  ItemCardCell.super.ctor(self, go)
end

function ItemCardCell:Init()
  self:FindObj()
end

function ItemCardCell:FindObj()
  self.cardQuality1 = self:FindComponent("CardQuality1", UISprite)
  self.cardQuality = self:FindComponent("CardQuality", UISprite)
  self.cardpos = self:FindComponent("CardPosition", UISprite)
  self.cardicon = self:FindComponent("CardIcon", UISpriteEx)
  self.cardLvBg = self:FindGO("CardLvBg")
  self.cardLvLabel = self:FindComponent("CardLv", UILabel)
end

function ItemCardCell:SetData(data)
  if not self.gameObject then
    return
  end
  self.data = data
  if data and data.cardInfo then
    self.gameObject:SetActive(true)
    local mids = data.cardInfo.monsterID
    if mids and self.cardicon then
      if self.cardicon then
        local _, monsterID = next(mids)
        if monsterID and Table_Monster[monsterID] then
          local anchor = data.cardInfo.Anchor
          if anchor and anchor[1] and anchor[2] then
            anchor = Vector2(anchor[1], anchor[2])
          else
            anchor = Vector2(0.5, 0.5)
          end
          self.cardicon.gameObject:SetActive(true)
          self.cardicon.anchor = anchor
          local setSuc = IconManager:SetFaceIcon(Table_Monster[monsterID].Icon, self.cardicon)
          if not setSuc then
            setSuc = Table_Item[data.cardInfo.id] and IconManager:SetItemIcon(Table_Item[data.cardInfo.id].Icon, self.cardicon)
            if not setSuc then
              IconManager:SetFaceIcon(Table_Monster[10001].Icon, self.cardicon)
            end
          end
        else
          self.cardicon.gameObject:SetActive(false)
        end
      else
        errorLog("Not Find CardIcon")
      end
    end
    if GameConfig.CardPosIconConfig then
      local sname = GameConfig.CardPosIconConfig[data.staticData.Type] or ""
      IconManager:SetUIIcon(sname, self.cardpos)
    end
    if self.numLab then
      self.numLab.text = data.num
    end
    local quality = data:GetCardQuality()
    if self.cardQuality then
      local colorCfg = CardUIConfig_Quality[quality]
      if colorCfg then
        local succ, color = ColorUtil.TryParseHexString(colorCfg.cardQualityColor)
        self.cardQuality.color = color
      end
    end
    if self.cardQuality1 then
      local colorCfg = CardUIConfig_Quality[quality]
      if colorCfg then
        local succ, color = ColorUtil.TryParseHexString(colorCfg.bgColor)
        self.cardQuality1.color = color
      end
    end
    self.cardpos.color = Color(1, 1, 1)
    self.cardicon.color = Color(1, 1, 1)
    if data.cardLv and data.cardLv > 0 then
      self:ShowCardLv(true)
      if self.cardLvLabel then
        self.cardLvLabel.text = "+" .. data.cardLv
      end
    else
      self:ShowCardLv(false)
    end
  else
    self.gameObject:SetActive(false)
  end
end

function ItemCardCell:SetIcon(spriteName)
end

function ItemCardCell:SetCardGrey(grey)
  if grey == nil then
    grey = false
  end
  if grey then
    self.cardQuality.color = Color(0.615686274509804, 0.615686274509804, 0.615686274509804, 0.6274509803921569)
    self.cardQuality1.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
    self.cardpos.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
    self.cardicon.color = Color(0.00392156862745098, 0.00784313725490196, 0.011764705882352941, 0.6274509803921569)
  else
    local data = self.data
    if not data then
      return
    end
    local quality = data:GetCardQuality()
    if self.cardQuality then
      local colorCfg = CardUIConfig_Quality[quality]
      if colorCfg then
        local succ, color = ColorUtil.TryParseHexString(colorCfg.cardQualityColor)
        self.cardQuality.color = color
      end
    end
    if self.cardQuality1 then
      local colorCfg = CardUIConfig_Quality[quality]
      if colorCfg then
        local succ, color = ColorUtil.TryParseHexString(colorCfg.bgColor)
        self.cardQuality1.color = color
      end
    end
    self.cardpos.color = Color(1, 1, 1)
    self.cardicon.color = Color(1, 1, 1)
  end
end

function ItemCardCell:ShowCardLv(show)
  if self.cardLvBg then
    self.cardLvBg:SetActive(show)
  end
end
