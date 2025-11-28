HeadwearRaidMonsterInfoView = class("HeadwearRaidMonsterInfoView", ContainerView)
HeadwearRaidMonsterInfoView.ViewType = UIViewType.TipLayer
autoImport("HeadWearRaidBatchCombineCell")

function HeadwearRaidMonsterInfoView:Init()
  self:InitData()
  self:InitView()
  self:AddEvents()
end

function HeadwearRaidMonsterInfoView:AddEvents()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadingSceneView.ServerReceiveLoaded, self.CloseSelf)
end

function HeadwearRaidMonsterInfoView:InitData()
  local autoHide = self.viewdata and self.viewdata.viewdata and self.viewdata.viewdata.autoHide
  if autoHide then
    self.timeTickId = self.timeTickId == nil and 1 or self.timeTickId + 1
    TimeTickManager.Me():CreateTick(autoHide * 1000, 33, function()
      self:CloseSelf()
    end, self, self.timeTickId, false, 1)
  end
end

function HeadwearRaidMonsterInfoView:InitView()
  self.debuglb = self:FindComponent("debuglb", UILabel)
  self.tips = self:FindComponent("Label", UILabel)
  self.tips.text = ZhString.HeadWearRaidMonsterInfo_TipsInfo
  self.batchGrid = self:FindGO("BatchGrid"):GetComponent(UIGrid)
  self.batchGridCtrl = UIGridListCtrl.new(self.batchGrid, HeadWearRaidBatchCombineCell, "HeadWearRaidBatchCombineCell")
end

function HeadwearRaidMonsterInfoView:OnEnter()
  HeadwearRaidMonsterInfoView.super.OnEnter(self)
  if not self.inited then
    self:UpdateMonsterInfo()
    self.inited = true
  end
end

function HeadwearRaidMonsterInfoView:OnExit()
  HeadwearRaidMonsterInfoView.super.OnExit(self)
  if self.autoHideTimer then
    TimeTickManager.Me():ClearTick(self)
    self.autoHideTimer = nil
  end
end

function HeadwearRaidMonsterInfoView:UpdateMonsterInfo()
  local str = ""
  for _, v in pairs(HeadwearRaidProxy.Instance.monsters) do
    str = str .. "波数:" .. v.round .. "  怪物A:" .. (Table_Monster[v.first] and Table_Monster[v.first].NameZh or v.first) .. "  怪物B:" .. (Table_Monster[v.second] and Table_Monster[v.second].NameZh or v.second) .. "\n"
  end
  self.debuglb.text = str
  local monstersData = HeadwearRaidProxy.Instance:GetMonsterList()
  local newData = self:ReUniteCellData(monstersData, 5)
  self.batchGridCtrl:ResetDatas(newData)
end

function HeadwearRaidMonsterInfoView:ReUniteCellData(datas, perRowNum)
  local newData = {}
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / perRowNum) + 1
      local i2 = math.floor((i - 1) % perRowNum) + 1
      newData[i1] = newData[i1] or {}
      if datas[i] == nil then
        newData[i1][i2] = nil
      else
        newData[i1][i2] = datas[i]
      end
    end
  end
  return newData
end
