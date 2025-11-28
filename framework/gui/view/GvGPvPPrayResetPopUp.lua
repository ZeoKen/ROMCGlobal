GvGPvPPrayResetPopUp = class("GvGPvPPrayResetPopUp", ContainerView)
GvGPvPPrayResetPopUp.ViewType = UIViewType.PopUpLayer
autoImport("PrayResetCell")
local CFG = GameConfig.GvGPvP_PrayType
local INIT_TYPE = GuildCmd_pb.EPRAYTYPE_GVG_ATK
local RESET_COST, COST_ID

function GvGPvPPrayResetPopUp:Init(parent)
  local bord = self:FindGO("BgBord")
  self.title = self:FindComponent("Title", UILabel, bord)
  self.title.text = ZhString.GvGPvPPray_ResetView_Title
  self.resetBtn = self:FindGO("ResetBtn")
  self.fixedLab = self:FindComponent("FixedLab", UILabel, self.resetBtn)
  self.fixedLab.text = ZhString.GvGPvPPray_ResetView
  self.costIcon = self:FindComponent("CostIcon", UISprite, self.resetBtn)
  COST_ID = GameConfig.GuildPray.ResetCostID or 151
  local cost_name = Table_Item[COST_ID].Icon
  IconManager:SetItemIcon(cost_name, self.costIcon)
  self.costLab = self:FindComponent("CostLab", UILabel, self.resetBtn)
  RESET_COST = GameConfig.GuildPray.ResetGvGPvPCost or 60
  self.costLab.text = RESET_COST
  self:AddClickEvent(self.resetBtn, function(go)
    self:OnClickResetBtn()
  end)
  local grid = self:FindComponent("TypeGrid", UIGrid)
  self.gridListCtl = UIGridListCtrl.new(grid, PrayResetCell, "PrayResetCell")
  self.gridListCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickResetCell, self)
  local togList = {}
  for i = 1, #CFG do
    table.insert(togList, CFG[i])
  end
  self.gridListCtl:ResetDatas(togList)
  self.chooseTypeID = INIT_TYPE
  self:_refreshChoose()
end

function GvGPvPPrayResetPopUp:OnClickResetCell(cellctl)
  if cellctl and cellctl.data and cellctl.data.type ~= self.chooseTypeID then
    self.chooseTypeID = cellctl.data.type
    self:_refreshChoose()
  end
end

function GvGPvPPrayResetPopUp:_refreshChoose()
  if self.gridListCtl then
    local childCells = self.gridListCtl:GetCells()
    for i = 1, #childCells do
      childCells[i]:SetChoose(self.chooseTypeID)
    end
  end
end

function GvGPvPPrayResetPopUp:OnClickResetBtn()
  if not GuildPrayProxy.Instance:CheckGVGPrayed(self.chooseTypeID) then
    MsgManager.ShowMsgByIDTable(34023)
    return
  end
  if BagProxy.Instance:GetItemNumByStaticID(COST_ID) < RESET_COST then
    MsgManager.ShowMsgByID(9513)
    return
  end
  if not BranchMgr.IsJapan() then
    MsgManager.ConfirmMsgByID(34011, function()
      ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(GuildCmd_pb.EPRAYACTION_RESET, self.chooseTypeID)
      self:CloseSelf()
    end, nil, nil, RESET_COST)
  else
    local chooseId = self.chooseTypeID
    OverseaHostHelper:GachaUseComfirm(RESET_COST, function()
      ServiceGuildCmdProxy.Instance:CallPrayGuildCmd(GuildCmd_pb.EPRAYACTION_RESET, chooseId)
      self:CloseSelf()
    end)
  end
end
