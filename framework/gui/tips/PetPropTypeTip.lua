autoImport("PropTypeTip")
PetPropTypeTip = class("PetPropTypeTip", PropTypeTip)
local tempVector3 = LuaVector3.Zero()
local Localize = function(text)
  if OverSea and OverSea.LangManager and OverSea.LangManager.Instance then
    local translated = OverSea.LangManager.Instance():GetLangByKey(text)
    if translated and translated ~= "" then
      return translated
    end
  end
  return text
end
local LocalizeZhString = function(key)
  return Localize(ZhString[key])
end
local GROUPS = {
  {
    id = "level",
    nameKey = "PetPropTypeTip_GroupLevel"
  },
  {
    id = "friendlv",
    nameKey = "PetPropTypeTip_GroupFriendLevel"
  },
  {
    id = "nature",
    nameKey = "PetPropTypeTip_GroupNature"
  },
  {
    id = "race",
    nameKey = "PetPropTypeTip_GroupRace"
  },
  {
    id = "shape",
    nameKey = "PetPropTypeTip_GroupShape"
  },
  {
    id = "favorite",
    nameKey = "PetPropTypeTip_GroupFavorite"
  },
  {
    id = "mount",
    nameKey = "PetPropTypeTip_GroupMount"
  },
  {
    id = "pvp",
    nameKey = "PetPropTypeTip_GroupPvp"
  }
}
local SHAPE_NAMES = {
  L = "PetPropTypeTip_ShapeLarge",
  M = "PetPropTypeTip_ShapeMedium",
  S = "PetPropTypeTip_ShapeSmall"
}
local GetPetMaxLevel = function()
  local systemMaxLevel = GameConfig and GameConfig.System and GameConfig.System.maxbaselevel
  if type(systemMaxLevel) == "number" and 0 < systemMaxLevel then
    return systemMaxLevel
  end
  local maxLevel = 0
  for level, _ in pairs(Table_PetBaseLevel or {}) do
    if type(level) == "number" and level > maxLevel then
      maxLevel = level
    end
  end
  return 0 < maxLevel and maxLevel or 170
end
local MakeOptions = function(groupID)
  local options = {}
  if groupID == "level" then
    local maxLevel = GetPetMaxLevel()
    for i = 1, math.ceil(maxLevel / 10) do
      local minLv = (i - 1) * 10 + 1
      local maxLv = math.min(i * 10, maxLevel)
      options[#options + 1] = {
        id = i,
        min = minLv,
        max = maxLv,
        name = string.format("%d-%d", minLv, maxLv)
      }
    end
  elseif groupID == "friendlv" then
    for i = 1, 10 do
      options[#options + 1] = {
        id = i,
        value = i,
        name = string.format(LocalizeZhString("PetPropTypeTip_FriendLevel"), i)
      }
    end
  elseif groupID == "nature" then
    local values = {
      "Water",
      "Fire",
      "Wind",
      "Earth",
      "Neutral",
      "Shadow",
      "Holy",
      "Ghost",
      "Undead",
      "Poison"
    }
    for i = 1, #values do
      local value = values[i]
      local name = GameConfig.MonsterAttr.Nature[value] or value
      options[#options + 1] = {
        id = value,
        value = value,
        name = Localize(name)
      }
    end
  elseif groupID == "race" then
    local values = {
      "Formless",
      "Undead",
      "Brute",
      "Plant",
      "Insect",
      "Fish",
      "Demon",
      "DemiHuman",
      "Angel",
      "Dragon"
    }
    for i = 1, #values do
      local value = values[i]
      local name = GameConfig.MonsterAttr.Race[value] or value
      options[#options + 1] = {
        id = value,
        value = value,
        name = Localize(name)
      }
    end
  elseif groupID == "shape" then
    local values = {
      "L",
      "M",
      "S"
    }
    for i = 1, #values do
      local value = values[i]
      options[#options + 1] = {
        id = value,
        value = value,
        name = LocalizeZhString(SHAPE_NAMES[value])
      }
    end
  elseif groupID == "favorite" then
    options = {
      {
        id = "true",
        value = true,
        name = LocalizeZhString("PetPropTypeTip_Favorite")
      },
      {
        id = "false",
        value = false,
        name = LocalizeZhString("PetPropTypeTip_NotFavorite")
      }
    }
  elseif groupID == "mount" then
    options = {
      {
        id = "true",
        value = true,
        name = LocalizeZhString("PetPropTypeTip_Mountable")
      },
      {
        id = "false",
        value = false,
        name = LocalizeZhString("PetPropTypeTip_NotMountable")
      }
    }
  elseif groupID == "pvp" then
    options = {
      {
        id = "true",
        value = true,
        name = LocalizeZhString("PetPropTypeTip_PvpPet")
      },
      {
        id = "false",
        value = false,
        name = LocalizeZhString("PetPropTypeTip_NotPvpPet")
      }
    }
  end
  return options
end

function PetPropTypeTip:Init()
  self.groups = {}
  self.groupOptions = {}
  self.selectedGroups = {}
  self.currentGroup = "level"
  PetPropTypeTip.super.Init(self)
end

function PetPropTypeTip:initView()
  PetPropTypeTip.super.initView(self)
  self.itemScrollView = self:FindComponent("ItemScrollView", UIScrollView)
  self.nameInput = self:FindComponent("NameInput", UIInput)
  if self.nameInput then
    self.nameInput.defaultText = LocalizeZhString("PetPropTypeTip_SearchPlaceholder")
    EventDelegate.Set(self.nameInput.onChange, function()
      self.searchText = self.nameInput.value or ""
      if not self.suppressChooseEvent then
        self:ChooseEvent()
      end
    end)
  end
end

function PetPropTypeTip:SetData(data)
  self.callback = data.callback
  self.callbackParam = data.param
  self.searchText = data.keyword or ""
  self.groups = {}
  self.selectedGroups = {}
  for _, group in ipairs(GROUPS) do
    self.groups[#self.groups + 1] = {
      id = group.id,
      name = LocalizeZhString(group.nameKey)
    }
    self.selectedGroups[group.id] = {}
    self.groupOptions[group.id] = MakeOptions(group.id)
    for key, value in pairs(data.groups and data.groups[group.id] or {}) do
      self.selectedGroups[group.id][key] = value
    end
  end
  if self.nameInput then
    self.nameInput.value = self.searchText
  end
  self.propDatas = self.groups
  self.propGrid:ResetDatas(self.propDatas)
  self:UpdateContentLayout()
  self:SetGroup(self.currentGroup)
  self:ChooseEvent()
  self.itemScrollView:ResetPosition()
end

function PetPropTypeTip:UpdateContentLayout()
  local keepCustomContent = self.nameInput and self.nameInput.transform:IsChildOf(self.customContent.transform)
  if not keepCustomContent then
    self.customContent:SetActive(false)
  end
  local bounds = NGUIMath.CalculateRelativeWidgetBounds(self.customContent.transform)
  local height = bounds.size.y
  local x, y, z = LuaGameObject.GetLocalPosition(self.customContent.transform)
  y = y - height - 30
  local firstX, _, firstZ = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  LuaVector3.Better_Set(tempVector3, firstX, y, firstZ)
  self.firstContent.transform.localPosition = tempVector3
  bounds = NGUIMath.CalculateRelativeWidgetBounds(self.firstContent.transform)
  height = bounds.size.y
  x, y, z = LuaGameObject.GetLocalPosition(self.firstContent.transform)
  y = y - height - 30
  local secondX, _, secondZ = LuaGameObject.GetLocalPosition(self.secondContent.transform)
  LuaVector3.Better_Set(tempVector3, secondX, y, secondZ)
  self.secondContent.transform.localPosition = tempVector3
end

function PetPropTypeTip:SetGroup(groupID)
  self.currentGroup = groupID or self.currentGroup
  for _, cell in ipairs(self.propGrid:GetCells()) do
    cell:SetIsSelect(cell.data and cell.data.id == self.currentGroup)
  end
  self.keyworkGrid:ResetDatas(self.groupOptions[self.currentGroup] or {})
  local selected = self.selectedGroups[self.currentGroup] or {}
  for _, cell in ipairs(self.keyworkGrid:GetCells()) do
    cell:SetIsSelect(selected[cell.id] == true)
  end
  self.emptyCt:SetActive(#(self.groupOptions[self.currentGroup] or {}) == 0)
end

function PetPropTypeTip:PropClick(cell)
  if cell and cell.data then
    if self.currentGroup ~= cell.data.id then
      self.selectedGroups[self.currentGroup] = {}
    end
    for _, item in ipairs(self.propGrid:GetCells()) do
      item:SetIsSelect(item == cell)
    end
    self:SetGroup(cell.data.id)
    self:ChooseEvent()
  end
end

function PetPropTypeTip:KeyworkClick(cell)
  if cell and cell.data then
    local selected = self.selectedGroups[self.currentGroup]
    selected[cell.id] = not selected[cell.id]
    cell:SetIsSelect(selected[cell.id] == true)
    self:ChooseEvent()
  end
end

function PetPropTypeTip:ChooseEvent()
  if self.callback then
    self.callback(self.callbackParam, {
      keyword = self.searchText or self.nameInput and self.nameInput.value or "",
      groups = self.selectedGroups
    })
  end
end

function PetPropTypeTip:OnResetBtnClick(suppressCallback)
  self.suppressChooseEvent = true
  for _, group in ipairs(GROUPS) do
    self.selectedGroups[group.id] = {}
  end
  self.searchText = ""
  if self.nameInput then
    self.nameInput.value = ""
  end
  self:SetGroup(self.currentGroup)
  self.suppressChooseEvent = false
  if not suppressCallback then
    self:ChooseEvent()
  end
end
