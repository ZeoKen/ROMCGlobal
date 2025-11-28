autoImport("DialogView")
DialogView_Popup = class("DialogView_Popup", DialogView)
DialogView_Popup.ViewType = UIViewType.Lv4PopUpLayer

function DialogView_Popup:GetShowHideMode()
  return PanelShowHideMode.CreateAndDestroy
end

function DialogView_Popup:ResetViewData()
  self:UpdateViewData()
end
