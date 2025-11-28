autoImport("BattlePassPreviewCell")
BattlePassPreviewView = class("BattlePassPreviewView", SubView)
local Prefab_Path = ResourcePathHelper.UIView("BattlePassPreviewView")

function BattlePassPreviewView:LoadSubView()
  local container = self:FindGO("previewViewPos")
  local obj = self:LoadPreferb_ByFullPath(Prefab_Path, container, true)
  obj.name = "BattlePassPreviewView"
  self.gameObject = obj
end

function BattlePassPreviewView:Init()
  self:LoadSubView()
  self:InitView()
  self:InitData()
end

function BattlePassPreviewView:InitView()
  self:FindComponent("text4", UILabel, self.previewPanel).text = ZhString.ServantBattlePassView_text4
  self.list = UIGridListCtrl.new(self:FindComponent("container", UITable), BattlePassPreviewCell, "BattlePassPreviewCell")
  self.list:AddEventListener(MouseEvent.MouseClick, self.ClickRewardItemHandler, self)
  self.list:AddEventListener(BattlePassEvent.PreviewToggleShow, function()
    self.list:Layout()
  end, self)
  self:AddClickEvent(self:FindGO("CloseButton"), function()
    self:CloseSelf()
  end)
end

function BattlePassPreviewView:InitData()
end

function BattlePassPreviewView:CloseSelf()
  EventManager.Me():DispatchEvent(BattlePassEvent.HideRewardPreview)
end

function BattlePassPreviewView:OnEnter()
  BattlePassPreviewView.super.OnEnter(self)
  self:UpdateView()
end

function BattlePassPreviewView:UpdateView()
  local datas = {0}
  for i = 1, #BattlePassProxy.Instance.UpgradeDepositItem do
    TableUtility.ArrayPushBack(datas, i)
  end
  self.list:ResetDatas(datas)
end

local tipData = {}
tipData.funcConfig = {}

function BattlePassPreviewView:ClickRewardItemHandler(cellctl)
  if cellctl.data then
    tipData.itemdata = cellctl.data
    self:ShowItemTip(tipData, nil, NGUIUtil.AnchorSide.Up)
  end
end
