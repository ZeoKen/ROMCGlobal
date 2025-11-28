autoImport("NewbieTechTreeLevelCell")
NewbieTechtreeLeafTip = class("NewbieTechtreeLeafTip", CoreView)

function NewbieTechtreeLeafTip:ctor(obj, tipStick)
  NewbieTechtreeLeafTip.super.ctor(self, obj)
  self.tipStick = tipStick
  if not proxyIns then
    proxyIns = TechTreeProxy.Instance
  end
  self:FindObjs()
  self:InitShow()
end

function NewbieTechtreeLeafTip:FindObjs()
  self.nameLabel = self:FindGO("NameLabel"):GetComponent(UILabel)
  self.scrollView = self:FindComponent("LevelScrollView", UIScrollView)
  self.levelTable = self:FindGO("LevelTable"):GetComponent(UITable)
  self.levelGridCtrl = UIGridListCtrl.new(self.levelTable, NewbieTechTreeLevelCell, "NewbieTechTreeLevelCell")
  self.panel = self.scrollView.panel
end

function NewbieTechtreeLeafTip:InitShow()
end

function NewbieTechtreeLeafTip:SetData(branchID, treeID)
  if not branchID then
    return
  end
  local proxyIns = TechTreeProxy.Instance
  local leafs = proxyIns:GetLeafsByBranch(branchID)
  local result = {}
  for i = 1, #leafs do
    local leaf = leafs[i]
    local data = {
      leafId = leaf,
      isUnlock = proxyIns:IsLeafUnlocked(leaf, treeID)
    }
    table.insert(result, data)
  end
  self.levelGridCtrl:ResetDatas(result)
  self.scrollView:ResetPosition()
  if 43 < branchID then
    self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(-750, 0, 0)
  else
    self.gameObject.transform.localPosition = LuaVector3.Zero()
  end
  local nameConfig = GameConfig.NoviceTechTree and GameConfig.NoviceTechTree.TreeName
  for i = 1, 5 do
    if NewbieTechTreeHeartPage.BranchList[i] == branchID then
      self.nameLabel.text = nameConfig and nameConfig[i]
      break
    end
  end
end
