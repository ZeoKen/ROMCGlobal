autoImport("ItemCell")
ExpRaidQuickFinishChooseView = class("ExpRaidQuickFinishChooseView", BaseView)
ExpRaidQuickFinishChooseView.ViewType = UIViewType.PopUpLayer

function ExpRaidQuickFinishChooseView:Init()
  self.data = self.viewdata.viewdata
  self:FindObjs()
  self:InitDatas()
  self:InitShow()
  self:AddEvts()
  self:DefaultChoose()
end

function ExpRaidQuickFinishChooseView:FindObjs()
  self.normalGrid = self:FindComponent("NormalGrid", UIGrid)
  self.itemGrid = self:FindComponent("ItemGrid", UIGrid)
  self.normalToggle = self:FindComponent("NormalToggle", UIToggle)
  self.itemToggle = self:FindComponent("ItemToggle", UIToggle)
  self.useBtn = self:FindGO("UseBtn")
  self.tipStick = self:FindComponent("TipStick", UISprite)
  self.headTexture = self:FindGO("BG_decorate"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("reward_bg_decorate1", self.headTexture)
end

function ExpRaidQuickFinishChooseView:InitDatas()
  self.expItemDataList = {}
  self.itemItemDataList = {}
end

function ExpRaidQuickFinishChooseView:InitShow()
  self.normalRewardCtrl = UIGridListCtrl.new(self.normalGrid, BagItemCell, "BagItemCell")
  self.itemRewardCtrl = UIGridListCtrl.new(self.itemGrid, BagItemCell, "BagItemCell")
  self:UpdateRewards()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function ExpRaidQuickFinishChooseView:AddEvts()
  self:AddClickEvent(self.useBtn, function()
    self:ClickUse()
    self:CloseSelf()
  end)
  self.normalRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.itemRewardCtrl:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
end

function ExpRaidQuickFinishChooseView:DefaultChoose()
  self.normalToggle.value = true
end

function ExpRaidQuickFinishChooseView:UpdateRewards()
  local playerLevel = Game.Myself.data.userdata:Get(UDEnum.ROLELEVEL)
  local recommendRaid
  local recommendLevel = 0
  for k, v in pairs(Table_ExpRaid) do
    if playerLevel >= v.Level and recommendLevel <= v.Level then
      recommendRaid = v.id
      recommendLevel = v.Level
    end
  end
  self.raidId = recommendRaid
  TableUtility.TableClear(self.expItemDataList)
  TableUtility.TableClear(self.itemItemDataList)
  local prestigeData = ItemData.new("Prestige", 750000)
  local jobItemData = ItemData.new("JobExp", 400)
  local baseItemData = ItemData.new("BaseExp", 300)
  table.insert(self.expItemDataList, jobItemData)
  table.insert(self.expItemDataList, baseItemData)
  table.insert(self.expItemDataList, prestigeData)
  local itemRewardTeam = Table_ExpRaid[recommendRaid].NormalReward
  if itemRewardTeam and 0 < #itemRewardTeam then
    for i = 1, #itemRewardTeam do
      local rewardItemId = ItemUtil.GetRewardItemIdsByTeamId(itemRewardTeam[i])
      if rewardItemId and next(rewardItemId) then
        for _, data in pairs(rewardItemId) do
          local item = ItemData.new("Reward", data.id)
          table.insert(self.itemItemDataList, item)
        end
      end
    end
  end
  self.itemRewardCtrl:ResetDatas(self.expItemDataList)
  self.normalRewardCtrl:ResetDatas(self.itemItemDataList)
end

function ExpRaidQuickFinishChooseView:ClickUse()
  if self.normalToggle and self.normalToggle.value then
    ServiceNUserProxy.Instance:CallTeamExpRewardTypeCmd(self.raidId, 2)
  elseif self.itemToggle and self.itemToggle.value then
    ServiceNUserProxy.Instance:CallTeamExpRewardTypeCmd(self.raidId, 1)
  end
  FunctionItemFunc.DoUseItem(self.data, nil, 1)
end

function ExpRaidQuickFinishChooseView:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    self.tipData.itemdata = cellCtl.data
    self:ShowItemTip(self.tipData, self.tipStick, NGUIUtil.AnchorSide.Left)
  end
end

function ExpRaidQuickFinishChooseView:OnExit()
  PictureManager.Instance:UnLoadUI("reward_bg_decorate1", self.headTexture)
  ExpRaidQuickFinishChooseView.super.OnExit(self)
end
