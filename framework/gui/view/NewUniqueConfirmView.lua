NewUniqueConfirmView = class("NewUniqueConfirmView", BaseView)
NewUniqueConfirmView.ViewType = UIViewType.ConfirmLayer

function NewUniqueConfirmView:Init()
  self:InitObjects()
end

function NewUniqueConfirmView:InitObjects()
  self.closeBtn = self:FindGO("CloseButton")
  self.contentGO = self:FindGO("scrollview/ContentLabel")
  self.contentLabel = self.contentGO:GetComponent(UILabel)
  
  function self.contentLabel.onPostFill(widget)
    self:ResizeView()
  end
  
  self.bg = self:FindGO("Bg")
  self.bg_sp = self.bg:GetComponent(UISprite)
  self.pattern = self:FindGO("Partten")
  self.contentUpBg = self:FindGO("scrollviewbgup")
  self.contentDownBg = self:FindGO("scrollviewbgdown")
  self.scrollView = self:FindComponent("scrollview", UIScrollView)
  self.btns = self:FindGO("Btns")
  self.btnsGrid = self.btns:GetComponent(UIGrid)
  self.confirmBtn = self:FindGO("ConfirmBtn", self.btns)
  self.confirmBtn_Label = self:FindComponent("ConfirmLabel", UILabel, self.confirmBtn)
  self.cancelBtn = self:FindGO("CancelBtn", self.btns)
  self.cancelBtn_Label = self:FindComponent("CancelLabel", UILabel, self.cancelBtn)
  self.thaiFont = self:FindComponent("Thai", UIFont)
  self:AddClickEvent(self.closeBtn, function(go)
    self:CloseSelf()
  end)
  self:AddClickEvent(self.confirmBtn, function(go)
    self:DoConfirm()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.cancelBtn, function(go)
    self:DoCancel()
    self:CloseSelf()
  end)
end

function NewUniqueConfirmView:DoConfirm()
  if self.viewdata.confirmHandler ~= nil then
    self.viewdata.confirmHandler(self.viewdata.source)
  end
end

function NewUniqueConfirmView:DoCancel()
  if self.viewdata.cancelHandler ~= nil then
    self.viewdata.cancelHandler(self.viewdata.source)
  end
end

function NewUniqueConfirmView:SetClose()
  self.closeBtn:SetActive(self.viewdata.needCloseBtn == true)
end

function NewUniqueConfirmView:SetContent(text)
  text = text or self.viewdata.content
  local patTai = OverSea.LangManager.Instance():GetLangByKey(ZhString.LangSwitchPanel_Thai)
  if text then
    if string.match(text, patTai) then
      self.contentLabel.trueTypeFont = nil
      self.contentLabel.bitmapFont = self.thaiFont
    else
      self.contentLabel.trueTypeFont = nil
      self.contentLabel.bitmapFont = self.confirmBtn_Label.bitmapFont
    end
    if self.viewdata.lockreason then
      self.contentLabel.text = text .. "\n" .. self.viewdata.lockreason
    else
      self.contentLabel.text = text
    end
  end
end

function NewUniqueConfirmView:SetButton()
  local confirmtext = self.viewdata.confirmtext
  if confirmtext and confirmtext ~= "" then
    self.confirmBtn:SetActive(true)
    self.confirmBtn_Label.text = confirmtext
  else
    self.confirmBtn:SetActive(false)
  end
  local canceltext = self.viewdata.canceltext
  if canceltext and canceltext ~= "" then
    self.cancelBtn:SetActive(true)
    self.cancelBtn_Label.text = canceltext
  else
    self.cancelBtn:SetActive(false)
  end
  self.btnsGrid:Reposition()
end

function NewUniqueConfirmView:ResizeView()
  local labelHeight = self.contentLabel.height
  if 255 < labelHeight then
    self.contentLabel.pivot = UIWidget.Pivot.Top
    self.contentLabel.alignment = 1
    LuaGameObject.SetLocalPositionGO(self.contentGO, 0, 120, 0)
    LuaGameObject.SetLocalPositionGO(self.contentUpBg, 0, 171.5, 0)
    LuaGameObject.SetLocalPositionGO(self.contentDownBg, 0, -98, 0)
    LuaGameObject.SetLocalPositionGO(self.btns, 0, -148, 0)
    if self.closeBtn.activeSelf then
      LuaGameObject.SetLocalPositionGO(self.closeBtn, 248, 178, 0)
      LuaGameObject.SetLocalPositionGO(self.bg, 0, -14, 0)
      self.bg_sp.height = 460
    else
      LuaGameObject.SetLocalPositionGO(self.bg, 0, -14, 0)
      self.bg_sp.height = 422
    end
  else
    self.contentLabel.pivot = UIWidget.Pivot.Center
    self.contentLabel.alignment = 2
    LuaGameObject.SetLocalPositionGO(self.contentGO, 0, -10, 0)
    local bounds = self.contentLabel:CalculateBounds(self.trans)
    local content_UpY, content_DownY = bounds.max[2], bounds.min[2]
    local maxY, minY = content_UpY, content_DownY
    LuaGameObject.SetLocalPositionGO(self.contentUpBg, 0, content_UpY + 15, 0)
    if self.closeBtn.activeSelf then
      LuaGameObject.SetLocalPositionGO(self.closeBtn, 248, content_UpY + 15 + 12, 0)
      maxY = content_UpY + 15 + 12
    else
      maxY = content_UpY + 15
    end
    maxY = maxY + 30
    LuaGameObject.SetLocalPositionGO(self.contentDownBg, 0, content_DownY, 0)
    LuaGameObject.SetLocalPositionGO(self.btns, 0, content_DownY - 45, 0)
    minY = content_DownY - 45 - 40
    LuaGameObject.SetLocalPositionGO(self.bg, 0, (maxY + minY) / 2 - 10, 0)
    self.bg_sp.height = maxY - minY + 40
  end
end

function NewUniqueConfirmView:RefreshView()
  self:SetClose()
  self:SetButton()
  self:SetContent()
end

function NewUniqueConfirmView:OnEnter()
  UIManagerProxy.UniqueConfirmView = self
  NewUniqueConfirmView.super.OnEnter(self)
  self:RefreshView()
  EventManager.Me():AddEventListener("XDEChangeZ", self.OnCHangeZ, self)
end

function NewUniqueConfirmView:OnCHangeZ(data)
  local p = self.gameObject:GetComponent(UIPanel)
  p.depth = data.depth
  p = self.scrollView:GetComponent(UIPanel)
  p.depth = data.depth
end

function NewUniqueConfirmView:OnExit()
  if self.isHandled == false and self.viewdata.needExitDefaultHandle then
    self:DoCancel()
  end
  UIManagerProxy.UniqueConfirmView = nil
  self.viewdata = nil
  EventManager.Me():RemoveEventListener("XDEChangeZ", self.OnCHangeZ, self)
end
