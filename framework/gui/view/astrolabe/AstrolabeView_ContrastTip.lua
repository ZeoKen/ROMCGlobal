AstrolabeView_ContrastTip = class("AstrolabeView_ContrastTip", BaseTip)
autoImport("AstrolabeView_ContrastCell")
AstrolabeView_ContrastTip.ViewType = UIViewType.PopUpLayer
local config_PropName = Game.Config_PropName

function AstrolabeView_ContrastTip:Init()
  self:InitView()
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    TipsView.Me():HideCurrent()
  end
end

function AstrolabeView_ContrastTip:InitView()
  local leftBord = self:FindGO("LeftBord")
  local left_Grid = self:FindComponent("AttriGrid", UIGrid, leftBord)
  self.leftAttriCtl = UIGridListCtrl.new(left_Grid, AstrolabeView_ContrastCell, "AstrolabeView_ContrastCell")
  self.leftTotalCount = self:FindComponent("LeftTotalCount", UILabel, leftBord)
  self.leftCostInfoCells = {}
  self.leftCostInfoLabels = {}
  self.leftCostInfoSymbols = {}
  local leftCostGrid, go = self:FindGO("CostGrid", leftBord)
  for i = 1, 2 do
    go = self:FindGO("CostInfoCell" .. i, leftCostGrid)
    self.leftCostInfoCells[i] = go
    self.leftCostInfoLabels[i] = self:FindComponent("Label", UILabel, go)
    self.leftCostInfoSymbols[i] = self:FindComponent("Symbol", UISprite, go)
  end
  local rightBord = self:FindGO("RightBord")
  local right_Grid = self:FindComponent("AttriGrid", UIGrid, rightBord)
  self.rightAttriCtl = UIGridListCtrl.new(right_Grid, AstrolabeView_ContrastCell, "AstrolabeView_ContrastCell")
  self.rightTotalCount = self:FindComponent("RightTotalCount", UILabel, rightBord)
  self.rightCostInfoCells = {}
  self.rightCostInfoLabels = {}
  self.rightCostInfoSymbols = {}
  local rightCostGrid = self:FindGO("CostGrid", rightBord)
  for i = 1, 2 do
    go = self:FindGO("CostInfoCell" .. i, rightCostGrid)
    self.rightCostInfoCells[i] = go
    self.rightCostInfoLabels[i] = self:FindComponent("Label", UILabel, go)
    self.rightCostInfoSymbols[i] = self:FindComponent("Symbol", UISprite, go)
  end
  self.leftNoneTip = self:FindGO("NoneTip", leftBord)
  self.rightNoneTip = self:FindGO("NoneTip", rightBord)
end

function AstrolabeView_ContrastTip:UpdateView()
  local showCostInfo = GameConfig.Astrolabe.ShowCostInfo
  self.leftDatas = self.leftDatas or {}
  TableUtility.TableClear(self.leftDatas)
  local totalCount, totalCost = self:_HelpUpdateAttris(self.leftAttriCtl, self.savedata, self.leftDatas, self.leftNoneTip)
  self.leftTotalCount.text = string.format(ZhString.AstrolabeView_ContrastTip_SaveTotalCount, totalCount)
  local cellIndex, c = 1
  for i = 1, #showCostInfo do
    c = totalCost[showCostInfo[i]]
    if c then
      self.leftCostInfoCells[cellIndex]:SetActive(true)
      self.leftCostInfoLabels[cellIndex].text = c
      IconManager:SetItemIcon(Table_Item[showCostInfo[i]].Icon, self.leftCostInfoSymbols[cellIndex])
      cellIndex = cellIndex + 1
    end
  end
  for i = cellIndex, 2 do
    self.leftCostInfoCells[i]:SetActive(false)
  end
  self.rightDatas = self.rightDatas or {}
  TableUtility.TableClear(self.rightDatas)
  totalCount, totalCost = self:_HelpUpdateAttris(self.rightAttriCtl, self.newdata, self.rightDatas, self.rightNoneTip)
  self.rightTotalCount.text = string.format(ZhString.AstrolabeView_ContrastTip_NewTotalCount, totalCount)
  cellIndex = 1
  for i = 1, #showCostInfo do
    c = totalCost[showCostInfo[i]]
    if c then
      self.rightCostInfoCells[cellIndex]:SetActive(true)
      self.rightCostInfoLabels[cellIndex].text = c
      IconManager:SetItemIcon(Table_Item[showCostInfo[i]].Icon, self.rightCostInfoSymbols[cellIndex])
      cellIndex = cellIndex + 1
    end
  end
  for i = cellIndex, 2 do
    self.rightCostInfoCells[i]:SetActive(false)
  end
end

local tempTable = {}

function AstrolabeView_ContrastTip:_HelpUpdateAttris(ctl, srcdata, destdata, noneTip)
  local totalCount, totalCost = 0, {}
  TableUtility.TableClear(tempTable)
  local pointData, effectMap, cost, cid, cv
  for pid, _ in pairs(srcdata) do
    pointData = self.bordData:GetPointByGuid(pid)
    effectMap = pointData:GetEffect()
    if effectMap == nil then
      redlog(string.format("not find effect. id:(%s)", pid))
    else
      for ectType, value in pairs(effectMap) do
        tempTable[ectType] = tempTable[ectType] or 0
        tempTable[ectType] = tempTable[ectType] + value
      end
    end
    totalCount = totalCount + 1
    cost = pointData:GetCost()
    for i = 1, #cost do
      cid, cv = cost[i][1], cost[i][2]
      totalCost[cid] = totalCost[cid] or 0
      totalCost[cid] = totalCost[cid] + cv
    end
  end
  local insertSort = TableUtility.InsertSort
  for k, v in pairs(tempTable) do
    tempTable[k] = nil
    insertSort(destdata, {k, v}, function(l, r)
      return config_PropName[l[1]].id < config_PropName[r[1]].id
    end)
  end
  ctl:ResetDatas(destdata)
  if noneTip then
    noneTip:SetActive(#destdata == 0)
  end
  return totalCount, totalCost
end

function AstrolabeView_ContrastTip:SetData(data)
  if data == nil then
    self.bordData = AstrolabeProxy.Instance:GetCurBordData()
    self.newdata = {}
    self.savedata = {}
  else
    self.bordData = data.bordData
    self.newdata = data.newdata
    self.savedata = data.savedata
  end
  self:UpdateView()
end

function AstrolabeView_ContrastTip:DestroySelf()
  GameObject.Destroy(self.gameObject)
end
