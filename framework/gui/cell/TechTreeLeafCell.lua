local BaseCell = autoImport("BaseCell")
TechTreeLeafCell = class("TechTreeLeafCell", BaseCell)
TechTreeLeafCellState = {
  Locked = 0,
  Available = 1,
  Unlocked = 2,
  Hide = 3
}
TechTreeLeafCell.TreeIdBranchBgSpNameFormatMap = {
  [1] = {
    [1] = "tree_bg_b0%s",
    [2] = "tree_bg_a0%s",
    [3] = "tree_bg_b0%s",
    [4] = "tree_bg_a0%s",
    [5] = "tree_bg_b0%s",
    [6] = "tree_bg_a0%s"
  },
  [2] = {
    [1] = "tree_bg_b0%s_b",
    [2] = "tree_bg_a0%s_b",
    [3] = "tree_bg_b0%s_b",
    [4] = "tree_bg_a0%s_b",
    [5] = "tree_bg_b0%s_b",
    [6] = "tree_bg_a0%s_b"
  },
  [3] = {
    [11] = "tree_bg_b0%s",
    [21] = "tree_bg_a0%s",
    [12] = "tree_bg_b0%s",
    [22] = "tree_bg_a0%s",
    [13] = "tree_bg_b0%s",
    [23] = "tree_bg_a0%s"
  }
}
TechTreeLeafCell.TreeIdSharedBranchBgSpName = "tree_bg_a0%s_c"
TechTreeLeafCell.TreeIdBranchLeafLevelBgSpNameMap = {
  [1] = {
    [1] = "tree_icon_dot_b",
    [2] = "tree_icon_dot_a",
    [3] = "tree_icon_dot_b",
    [4] = "tree_icon_dot_a",
    [5] = "tree_icon_dot_b",
    [6] = "tree_icon_dot_a"
  },
  [2] = {
    [1] = "tree_icon_dot_b_b",
    [2] = "tree_icon_dot_a_b",
    [3] = "tree_icon_dot_b_b",
    [4] = "tree_icon_dot_a_b",
    [5] = "tree_icon_dot_b_b",
    [6] = "tree_icon_dot_a_b"
  },
  [3] = {
    [11] = "tree_icon_dot_b",
    [22] = "tree_icon_dot_a",
    [12] = "tree_icon_dot_b",
    [22] = "tree_icon_dot_a",
    [13] = "tree_icon_dot_b",
    [23] = "tree_icon_dot_a"
  }
}
local proxyIns
local IsNull = Slua.IsNull

function TechTreeLeafCell:ctor(go, id, treeId)
  if not proxyIns then
    proxyIns = TechTreeProxy.Instance
  end
  self.id = id
  self.treeId = treeId
  TechTreeLeafCell.super.ctor(self, go)
end

function TechTreeLeafCell:Init()
  self:FindObjs()
  self.branch = proxyIns:GetBranchIdOfLeaf(self.id)
  self.maxLevel = proxyIns:GetMaxLevelOfLeaf(self.id)
  local nameFormatMap = TechTreeLeafCell.TreeIdBranchBgSpNameFormatMap[self.treeId]
  if not nameFormatMap then
    LogUtility.WarningFormat("Cannot find NameFormatMap of treeId:{0}", self.treeId)
    return
  end
  local trees = proxyIns:GetStaticTreeIdsOfLeaf(self.id) or {}
  self.bgSpFormat = nameFormatMap[self.branch]
  self:SwitchToState(TechTreeLeafCellState.Locked, 1 < #trees)
  self:UpdateLevel()
  self:AddCellClickEvent()
  local effectGO = self:FindGO(EffectMap.UI.TechTreeLeafUnlocked)
  if not IsNull(effectGO) then
    GameObject.DestroyImmediate(effectGO)
  end
end

function TechTreeLeafCell:FindObjs()
  self.bg = self:FindComponent("LeafBg", UISprite)
  self.bgTrans = self.bg.transform
  self.icon = self:FindComponent("LeafIcon", UISprite)
  self.levelParent = self:FindGO("Levels")
  self:FindLevelObjs()
end

function TechTreeLeafCell:FindLevelObjs()
  self.levelGOs = {}
  local i, lvGO = 0
  while true do
    i = i + 1
    lvGO = self:FindGO(tostring(i), self.levelParent)
    if not lvGO then
      break
    end
    self.levelGOs[i] = lvGO
  end
end

function TechTreeLeafCell:SwitchToState(state, isSharedLeaf)
  if state == 3 then
    self.gameObject:SetActive(false)
  else
    self.gameObject:SetActive(true)
  end
  local bgSpKeyword = state == TechTreeLeafCellState.Locked and "2" or "1"
  if not isSharedLeaf then
    self.bg.spriteName = string.format(self.bgSpFormat, bgSpKeyword)
  else
    self.bg.spriteName = string.format(TechTreeLeafCell.TreeIdSharedBranchBgSpName, bgSpKeyword)
  end
  self.icon.color = LuaGeometry.GetTempColor(1, 1, 1, state == TechTreeLeafCellState.Unlocked and 1 or 0.5)
  if not IsNull(self.unlockedEffectGO) and state ~= TechTreeLeafCellState.Unlocked then
    GameObject.DestroyImmediate(self.unlockedEffectGO)
  elseif IsNull(self.unlockedEffectGO) and state == TechTreeLeafCellState.Unlocked then
    local effectPath = ResourcePathHelper.EffectUI(EffectMap.UI.TechTreeLeafUnlocked)
    self.unlockedEffectGO = self:LoadPreferb_ByFullPath(effectPath, self.gameObject.transform)
  end
  self.state = state
end

function TechTreeLeafCell:UpdateLevel()
  proxyIns:TrySetLeafIcon(self.id, self.icon)
  self.levelParent:SetActive(self.maxLevel ~= nil)
  if not self.maxLevel then
    return
  end
  local lv = proxyIns:GetCurLevelOfLeaf(self.id)
  self:_ForEachLevelGO(function(index, go)
    local isActive = index <= self.maxLevel
    go:SetActive(isActive)
    if not isActive then
      return
    end
    local bg = go:GetComponent(UISprite)
    bg.spriteName = TechTreeLeafCell.TreeIdBranchLeafLevelBgSpNameMap[self.treeId][self.branch]
    local icon = self:FindGO("Icon", go)
    icon:SetActive(lv ~= nil and index <= lv)
  end)
end

function TechTreeLeafCell:GetBgFlip()
  return self.bg.flip
end

function TechTreeLeafCell:_ForEachLevelGO(action)
  local go
  for i = 1, #self.levelGOs do
    go = self.levelGOs[i]
    if go then
      action(i, go)
    end
  end
end
