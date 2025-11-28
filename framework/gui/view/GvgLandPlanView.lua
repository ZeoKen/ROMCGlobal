local _GVGMgr
autoImport("GvgLandPlanCell")
GvgLandPlanView = class("GvgLandPlanView", ContainerView)
GvgLandPlanView.ViewType = UIViewType.NormalLayer

function GvgLandPlanView:Init()
  _GVGMgr = GvgProxy.Instance
  self:FindObj()
  self:AddEvent()
  self:InitUI()
end

function GvgLandPlanView:FindObj()
  self.title = self:FindComponent("Title", UILabel)
  self.titleCdLab = self:FindComponent("TitleCDLabel", UILabel)
  self.title.text = ZhString.GvgLandPlanView_Title
  self.confirmLab = self:FindComponent("ConfirmLab", UILabel)
end

function GvgLandPlanView:InitUI()
  local grid = self:FindComponent("ItemsGrid", UIGrid)
  self.listCtl = UIGridListCtrl.new(grid, GvgLandPlanCell, "GvgLandPlanCell")
end

function GvgLandPlanView:HandleTempOccupyFirstOptionLaunch()
  self:_UpdateTempOccupyBtn(true)
end

function GvgLandPlanView:HandleTempOccupyFirstOptionShutDown()
  self:_UpdateTempOccupyBtn(false)
end

function GvgLandPlanView:_UpdateTempOccupyBtn(var)
  local cells = self.listCtl:GetCells()
  if cells then
    for i = 1, #cells do
      cells[i]:RefreshTempOccupyBtn(var)
    end
  end
end

function GvgLandPlanView:AddEvent()
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(ServiceEvent.GuildCmdGvgSettleInfoGuildCmd, self.UpdateView)
  self:AddListenEvt(GVGEvent.GVG_FirstOptionLaunch, self.HandleTempOccupyFirstOptionLaunch)
  self:AddListenEvt(GVGEvent.GVG_FirstOptionShutDown, self.HandleTempOccupyFirstOptionShutDown)
end

function GvgLandPlanView:UpdateView()
  local data = _GVGMgr:GetGLandSettleData()
  if not next(data) then
    self:CloseSelf()
    return
  end
  self.listCtl:ResetDatas(data)
  self.confirmLab.text = _GVGMgr:IsPlanConfirmed() and ZhString.GvgLandPlanView_PlanSet or ZhString.GvgLandPlanView_ConfirmTip
  self:AddTick()
end

function GvgLandPlanView:AddTick()
  if not self.titleCdLab then
    return
  end
  if self.tick then
    return
  end
  self.endTimeStamp = _GVGMgr:GetSettleTime()
  if not self.endTimeStamp or self.endTimeStamp == 0 then
    return
  end
  self.tick = TimeTickManager.Me():CreateTick(0, 1000, self._updateCD, self, 1)
end

function GvgLandPlanView:RemoveTick()
  if self.tick then
    TimeTickManager.Me():ClearTick(self, 1)
    self.tick = nil
  end
  if self.titleCdLab then
    self.titleCdLab.text = ""
  end
end

function GvgLandPlanView:OnExit()
  self:RemoveTick()
  GvgLandPlanView.super.OnExit(self)
end

function GvgLandPlanView:OnEnter()
  GvgLandPlanView.super.OnEnter(self)
  self:UpdateView()
end

function GvgLandPlanView:_updateCD()
  local leftTime = self.endTimeStamp - ServerTime.CurServerTime() / 1000
  if leftTime <= 0 then
    self:RemoveTick()
    return
  end
  local min, sec = ClientTimeUtil.GetFormatSecTimeStr(leftTime)
  self.titleCdLab.text = string.format(ZhString.GvgLandPlanView_TitleCD, min, sec)
end
