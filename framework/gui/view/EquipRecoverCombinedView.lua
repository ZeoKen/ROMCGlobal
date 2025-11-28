autoImport("CommonCombineView")
EquipRecoverCombinedView = class("EquipRecoverCombinedView", CommonCombineView)
EquipRecoverCombinedView.ViewType = UIViewType.NormalLayer

function EquipRecoverCombinedView:InitConfig()
  self.TabGOName = {"Tab1", "Tab2"}
  self.TabIconMap = {
    Tab1 = "Disney_Magic-furnace_icon_reduction",
    Tab2 = "Disney_Magic-furnace_icon_break-down"
  }
  self.TabName = {
    ZhString.EquipRecover_EquipRecover,
    ZhString.EquipRecover_DeCompose
  }
  self.TabViewList = {
    PanelConfig.EquipRecoverView,
    PanelConfig.DeComposeNewView
  }
end

function EquipRecoverCombinedView:Init()
  self:InitConfig()
  self:InitData()
  self:InitView()
end

function EquipRecoverCombinedView:InitData()
  local viewdata = self.viewdata.viewdata
  if viewdata then
    self.npcData = viewdata.npcdata
    self.index = viewdata.index or 1
    self.isFromBag = viewdata.isFromBag
  end
end

function EquipRecoverCombinedView:SetStackViewIndex(index)
  local viewdata = self.viewdata.viewdata
  if viewdata then
    viewdata.index = index
  end
end

function EquipRecoverCombinedView:InitView()
  EquipRecoverCombinedView.super.InitView(self)
  self:AddListenEvt(ServiceEvent.PlayerMapChange, self.CloseSelf)
  self:AddListenEvt(LoadSceneEvent.BeginLoadScene, self.CloseSelf)
  self.isCombine = self.viewdata.viewdata and self.viewdata.viewdata.isCombine
  self.closeBtn = self:FindGO("CloseButton")
  if self.closeBtn then
    self.closeBtn:SetActive(not self.isCombine)
  end
end

function EquipRecoverCombinedView:JumpPanel(tabIndex)
  local viewdata = {}
  if self.viewdata and self.viewdata.viewdata then
    self.viewdata.viewdata.isCombine = true
    TableUtility.TableShallowCopy(viewdata, self.viewdata.viewdata)
  end
  if tabIndex == 1 then
    self:SetStackViewIndex(1)
    viewdata.isFromHomeWorkbench = true
    self:_JumpPanel("EquipRecoverView", viewdata)
  elseif tabIndex == 2 then
    self:SetStackViewIndex(2)
    viewdata.isnew = true
    self:_JumpPanel("DeComposeNewView", viewdata)
  end
end

function EquipRecoverCombinedView:_JumpPanel(panelKey, viewData)
  if not panelKey or not PanelConfig[panelKey] then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig[panelKey],
    viewdata = viewData
  })
end

function EquipRecoverCombinedView:OnEnter()
  EquipRecoverCombinedView.super.super.OnEnter(self)
  self:TabChangeHandler(self.index)
end

function EquipRecoverCombinedView:CloseSelf()
  EquipRecoverCombinedView.super.CloseSelf(self)
end

function EquipRecoverCombinedView:OnExit()
  EquipRecoverCombinedView.super.super.OnExit(self)
  self:sendNotification(UIEvent.CloseUI, {
    className = "EquipRecoverView",
    needRollBack = false
  })
  self:sendNotification(UIEvent.CloseUI, {
    className = "DeComposeNewView",
    needRollBack = false
  })
end
