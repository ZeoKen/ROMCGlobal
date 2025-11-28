local BaseCell = autoImport("BaseCell")
GFaithTypeCell = class("GFaithTypeCell", BaseCell)

function GFaithTypeCell:Init()
  self.name = self:FindComponent("NameLabel", UILabel)
  self.attriAdd = self:FindComponent("AttriAdd", UILabel)
end

function GFaithTypeCell:SetData(data)
  if data then
    local sData = data.staticData
    if OverSea.LangManager.Instance().CurSysLang == "Thai" then
      self.name.text = string.format("%s%s", ZhString.GFaithTypeCell_Pray, sData.Name)
    else
      self.name.text = string.format("%s%s", sData.Name, ZhString.GFaithTypeCell_Pray)
    end
    if sData.AttrIds and sData.AttrName then
      local nowValueMap = GuildFun.calcGuildPrayAttr(sData.id, data.level)
      local attrStrList = {}
      local attrNames = string.split(sData.AttrName, ",")
      for i, attriID in ipairs(sData.AttrIds) do
        local nowValue = nowValueMap[attriID] or 0
        local floorValue = math.floor(nowValue)
        local str = nowValue > floorValue and string.format("%s +%.1f", attrNames[i] or "", nowValue) or string.format("%s +%s", attrNames[i] or "", floorValue)
        table.insert(attrStrList, str)
      end
      self.attriAdd.text = table.concat(attrStrList, "\n")
    else
      self.attriAdd.text = ""
    end
  end
end
