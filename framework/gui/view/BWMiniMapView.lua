BWMiniMapView = class("BWMiniMapView", ContainerView)
BWMiniMapView.ViewType = UIViewType.ChatroomLayer
autoImport("BWMiniMapContentPage")
autoImport("BWMiniMapInfoPage")

function BWMiniMapView:Init()
  self.contentPage = self:AddSubView("BWMiniMapContentPage", BWMiniMapContentPage)
  self.infoPage = self:AddSubView("BWMiniMapInfoPage", BWMiniMapInfoPage)
  self.mapTween = self:FindComponent("MapBord", TweenPosition)
  self.infoTween = self:FindComponent("InfoBord", TweenAlpha)
  self.unlockUI = self:FindGO("UnlockUI")
  self.unlockUI:SetActive(false)
  local obj = self:LoadPreferb("cell/DialogCell", self:FindGO("Anchor_Bottom", self.unlockUI))
  self.dialogCtl = DialogCell.new(obj)
  self.dialogCtl:AddEventListener(MouseEvent.MouseClick, self.ClickUnLockDialog, self)
end

function BWMiniMapView:ClickUnLockDialog(cell)
  self.unlockUI:SetActive(false)
end

function BWMiniMapView:ShowUnlockDialog(dialogId)
  local data = DialogUtil.GetDialogData(dilg)
  self.dialogCtl:SetData(data)
  self.unlockUI:SetActive(true)
end

function BWMiniMapView:GetWindow()
  return self.contentPage and self.contentPage.window
end

function BWMiniMapView:ToggleInfoBord(val)
  if self.infoPage then
    if val then
      self.infoPage:Show()
      self.mapTween:ResetToBeginning()
      self.mapTween:PlayForward()
      self.infoTween:ResetToBeginning()
      self.infoTween:PlayForward()
    else
      self.infoPage:Hide()
      self.mapTween:PlayReverse()
      self.infoTween:PlayReverse()
    end
  end
end

function BWMiniMapView:ToggleAreaBord(val)
  if self.infoPage then
    if val then
      self.infoPage:Show()
    else
      self.infoPage:Hide()
    end
  end
end

function BWMiniMapView:OnEnter()
  BWMiniMapView.super.OnEnter(self)
  EventManager.Me():AddEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneBeginChanged, self)
end

function BWMiniMapView:OnSceneBeginChanged()
  self:CloseSelf()
end

function BWMiniMapView:OnExit()
  BWMiniMapView.super.OnExit(self)
  EventManager.Me():RemoveEventListener(LoadSceneEvent.FinishLoadScene, self.OnSceneBeginChanged, self)
end
