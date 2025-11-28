ShowPicturePopup = class("ShowPicturePopup", BaseView)
ShowPicturePopup.ViewType = UIViewType.PopUpLayer

function ShowPicturePopup:Init()
  self:FindObjs()
  self:InitDatas()
  self:InitShow()
end

function ShowPicturePopup:FindObjs()
  self.texture = self:FindGO("PlotPic"):GetComponent(UITexture)
  self.bgTexture1 = self:FindGO("BGTexture1"):GetComponent(UITexture)
  self.bgTexture2 = self:FindGO("BGTexture2"):GetComponent(UITexture)
  self.tipLabel = self:FindGO("TipLabel"):GetComponent(UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack()
    self:CloseSelf()
  end
end

function ShowPicturePopup:InitDatas()
  local viewdata = self.viewdata and self.viewdata.viewdata
  local questData = viewdata and viewdata.questData
  self.showPicPath = questData and questData.params and questData.params.ShowPic or "new_npc_pic_1"
  self.showPicTipID = questData and questData.params and questData.params.ShowPicTip or 146959
  xdlog("showpicPath", self.showPicPath, self.showPicTipID)
end

function ShowPicturePopup:InitShow()
  PictureManager.Instance:SetPlotPic(self.showPicPath, self.texture)
  if self.showPicTipID then
    local dialogData = DialogUtil.GetDialogData(self.showPicTipID)
    local text = dialogData and dialogData.Text or "?"
    self.tipLabel.text = text
  end
end

function ShowPicturePopup:OnEnter()
  ShowPicturePopup.super.OnEnter(self)
  PictureManager.Instance:SetUI("renwudian_zuizhong_bg1", self.bgTexture1)
  PictureManager.Instance:SetUI("renwudian_zuizhong_bg2", self.bgTexture2)
end

function ShowPicturePopup:OnExit()
  xdlog("OnExit")
  ShowPicturePopup.super.OnExit(self)
  PictureManager.Instance:UnLoadUI("renwudian_zuizhong_bg1", self.bgTexture1)
  PictureManager.Instance:UnLoadUI("renwudian_zuizhong_bg2", self.bgTexture2)
  PictureManager.Instance:UnLoadPlotPic(self.showPicPath, self.texture)
end
