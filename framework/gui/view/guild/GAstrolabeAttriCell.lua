local BaseCell = autoImport("BaseCell")
GAstrolabeAttriCell = class("GAstrolabeAttriCell", BaseCell)

function GAstrolabeAttriCell:Init()
  self.name = self:FindComponent("NameLabel", UILabel)
  self.attriAdd = self:FindComponent("AttriAdd", UILabel)
  self.bg = self.gameObject:GetComponent(UISprite)
end

function GAstrolabeAttriCell:SetData(data)
  if data then
    if data.m_isAttribute then
      local attribute = data.m_data
      self.name.text = attribute.staticData.AttrName
      local cur = attribute.curPray.attrValue
      if attribute.curPray.attrStaticData == nil then
        self.attriAdd.text = 0
      else
        self.attriAdd.text = attribute.curPray.attrStaticData.IsPercent == 1 and string.format("%s%%", cur / 100) or cur / 10000
      end
      local colorConifg = Table_GFaithUIColorConfig[attribute.staticData.ColorID]
      if colorConifg ~= nil then
        local hasc, rc = ColorUtil.TryParseHexString(colorConifg.bg_Color)
        self.bg.color = rc
      end
    else
      self.bg.color = ColorUtil.NGUIWhite
      local pro = Game.Config_PropName[data[1]]
      self.name.text = pro.PropName
      local config = Game.Config_PropName[data[1]]
      if config ~= nil then
        self.name.text = config.PropName
        local str = ""
        if 0 < data[2] then
          str = str .. " +"
        end
        if config.IsPercent == 1 then
          str = str .. data[2] * 100 .. "%"
        else
          str = str .. data[2]
        end
        self.attriAdd.text = str
      else
        redlog("Canot Find Attri" .. " ID:" .. data.guid)
      end
    end
  end
end
