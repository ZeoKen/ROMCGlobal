local BaseCell = autoImport("BaseCell")
BWNearlyCreatureCell = class("BWNearlyCreatureCell", BaseCell)

function BWNearlyCreatureCell:Init()
  self.playerProGO = self:FindGO("ProSymbol")
  self.playerPro = self.playerProGO:GetComponent(UISprite)
  self.levelGO = self:FindGO("Level")
  self.level = self.levelGO:GetComponent(UILabel)
  self.playerGenderGO = self:FindGO("Gender")
  self.playerGender = self.playerGenderGO:GetComponent(UISprite)
  self.nameGO = self:FindGO("Name")
  self.name = self.nameGO:GetComponent(UILabel)
  self.npcNameGO = self:FindGO("NpcName")
  self.npcName = self.npcNameGO:GetComponent(UILabel)
  self.symbolGO = self:FindGO("Symbol")
  self.symbol = self.symbolGO:GetComponent(UISprite)
  self.mapIndex = self:FindComponent("Map_Index", UILabel)
  self:AddCellClickEvent()
end

function BWNearlyCreatureCell:SetData(data)
  if data == nil then
    self.gameObject:SetActive(false)
    return
  end
  self.id = data.id
  self.gameObject:SetActive(true)
  self.playerProGO:SetActive(false)
  self.playerGenderGO:SetActive(false)
  self.mapIndex.text = ""
  self.symbol.spriteName = ""
  self.isExitPoint = data:GetParama("isExitPoint")
  if self.isExitPoint then
    self.nameGO:SetActive(false)
    self.npcNameGO:SetActive(true)
    self.pos = data.pos:Clone()
    self.nextSceneID = data:GetParama("nextSceneID")
    if Table_Map[self.nextSceneID] == nil then
      self.gameObject:SetActive(false)
      return
    end
    local name = Table_Map[self.nextSceneID].CallZh
    if name == "" then
      name = Table_Map[self.nextSceneID].NameZh
    end
    self.npcName.text = name
    IconManager:SetMapIcon("map_raid", self.symbol)
    MiniMapWindow.SetLetterOfExitPoint(self.mapIndex, data)
    return
  end
  self.creatureType = data:GetParama("creatureType")
  local name = data:GetParama("name")
  if self.creatureType == Creature_Type.Npc then
    self.levelGO:SetActive(false)
    self.nameGO:SetActive(false)
    self.npcNameGO:SetActive(true)
    local symbol = data:GetParama("Symbol")
    local config = symbol and QuestSymbolConfig[symbol]
    local questSymbol = config and config.UISpriteName
    if questSymbol then
      local isSuc = IconManager:SetMapIcon(questSymbol, self.symbol)
      if questSymbol == "map_icon_talk" then
        self.symbol.width = 20
        self.symbol.height = 18
      else
        self.symbol.width = 11
        self.symbol.height = 27
      end
    else
      local icon = data:GetParama("icon")
      IconManager:SetMapIcon(icon, self.symbol)
      self.symbol.width = 25
      self.symbol.height = 25
    end
    local posTip = data:GetParama("PositionTip")
    if posTip ~= "" then
      self.npcName.text = string.format(ZhString.BWNearlyCreatureCell_NameTip, posTip, name)
    else
      self.npcName.text = name
    end
    UIUtil.WrapLabel(self.npcName)
    self.pos = data.pos:Clone()
    self.npcid = data:GetParama("npcid")
    self.uniqueid = data:GetParama("uniqueid")
  elseif self.creatureType == Creature_Type.Player then
    self.playerProGO:SetActive(true)
    self.playerGenderGO:SetActive(true)
    self.levelGO:SetActive(true)
    self.nameGO:SetActive(true)
    self.npcNameGO:SetActive(false)
    self.level.text = string.format("Lv.%s", data:GetParama("level"))
    self.name.text = data:GetParama("name")
    UIUtil.WrapLabel(self.name)
    local playerPro = data:GetParama("Profession")
    if playerPro and Table_Class[playerPro] then
      IconManager:SetProfessionIcon(Table_Class[playerPro].icon, self.playerPro)
    end
    local gender = data:GetParama("gender")
    self.playerGender.spriteName = gender == 1 and "friend_icon_man" or "friend_icon_woman"
  else
    self.gameObject:SetActive(false)
  end
end
