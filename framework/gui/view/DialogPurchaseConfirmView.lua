DialogPurchaseConfirmView = class("DialogPurchaseConfirmView", SubMediatorView)

function DialogPurchaseConfirmView:OnEnter(subId)
  DialogPurchaseConfirmView.super.OnEnter(self)
  EventManager.Me():AddEventListener("XDEChangeZ", self.OnCHangeZ, self)
end

function DialogPurchaseConfirmView:OnExit()
  DialogPurchaseConfirmView.super.OnExit(self)
  EventManager.Me():RemoveEventListener("XDEChangeZ", self.OnCHangeZ, self)
end

function DialogPurchaseConfirmView:Init()
  if not BranchMgr.IsJapan() then
    return
  end
  self:FindObj()
  self:AddButtonEvt()
  self:AddViewEvt()
  self:RefreshView()
  self:RefreshDetail()
end

function DialogPurchaseConfirmView:FindObj()
  self.gameObject = self:LoadPreferb("view/NewShopConfirmPanel", nil, true)
  self.bg = self:FindGO("bg")
  self.bg_sp = self.bg:GetComponent(UISprite)
  self.panelAction = self:FindGO("pannelAction")
  local cancelBtn = self:FindGO("cancel", self.panelAction)
  self:AddClickEvent(cancelBtn, function(go)
    self:dealCancelCallBack()
  end)
  self.cancelLabel = self:FindComponent("Title", UILabel, cancelBtn)
  local confirmBtn = self:FindGO("comfirm", self.panelAction)
  self:AddClickEvent(confirmBtn, function(go)
    self:dealCallback()
  end)
  self.confirmLabel = self:FindComponent("Title", UILabel, confirmBtn)
  self.contentDownBg = self:FindGO("scrollviewbgdown")
  self.desRoot = self:FindGO("desroot")
  self.desRootTrans = self.desRoot.transform
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.des = self:FindGO("des"):GetComponent(UILabel)
  
  function self.des.onPostFill(widget)
    self:ResizeView(widget)
  end
end

function DialogPurchaseConfirmView:AddButtonEvt()
end

function DialogPurchaseConfirmView:AddViewEvt()
end

function DialogPurchaseConfirmView:dealCancelCallBack()
  if self.cancelCallback then
    self.cancelCallback()
  end
  xdlog("点击取消")
  local questId = self.viewdata.questId
  xdlog("questid ", questId, self.confirmOption)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, self.cancelOption)
  end
  self.container:CloseSelf()
end

function DialogPurchaseConfirmView:dealCallback()
  if self.callback then
    self.callback()
  end
  local questId = self.viewdata.questId
  xdlog("questid ", questId, self.confirmOption)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData then
    QuestProxy.Instance:notifyQuestState(questData.scope, questData.id, self.confirmOption)
  end
  xdlog("点击确认")
  self.container:CloseSelf()
end

function DialogPurchaseConfirmView:ResizeView(deslab)
  local titleHeight = self.showTitle and 40 or 0
  if deslab.height > 255 then
    self.des.alignment = 1
    self.bg_sp.height = 411 + titleHeight
    LuaGameObject.SetLocalPositionGO(self.contentDownBg, 0, -135, 0)
    LuaGameObject.SetLocalPositionGO(self.panelAction, 0, -180, 0)
  else
    self.des.alignment = 1
    local bounds = self.des:CalculateBounds(self.desRootTrans)
    local content_UpY, content_DownY = bounds.max[2], bounds.min[2]
    LuaGameObject.SetLocalPositionGO(self.contentDownBg, 0, content_DownY, 0)
    LuaGameObject.SetLocalPositionGO(self.panelAction, 0, content_DownY - 52, 0)
    self.bg_sp.height = 157 - (content_DownY - 52 - 72) + titleHeight
  end
end

function DialogPurchaseConfirmView:RefreshView()
  local msgData = Table_Sysmsg[43233]
  if not msgData then
    return
  end
  local title = msgData.Title
  if title then
    self.title.text = title
    self.showTitle = true
    LuaGameObject.SetLocalPositionGO(self.desRoot, 0, 10, 0)
  else
    self.title.text = ""
    self.showTitle = false
    LuaGameObject.SetLocalPositionGO(self.desRoot, 0, 50, 0)
  end
  local descStr = string.format(msgData.Text, 88)
  self.des.text = descStr
  local questId = self.viewdata.questId
  xdlog("questid ", questId)
  local questData = QuestProxy.Instance:getQuestDataByIdAndType(questId)
  if questData then
    local nowDialogData = self.container.nowDialogData
    if nowDialogData then
      local optionConfig = StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(nowDialogData.Option))
      if optionConfig and 0 < #optionConfig then
        xdlog("选项", #optionConfig)
        if optionConfig[1] then
          self.confirmLabel.text = optionConfig[1].text
          self.confirmOption = optionConfig[1].id
        end
        if optionConfig[2] then
          self.cancelLabel.text = optionConfig[2].text
          self.cancelOption = optionConfig[2].id
        end
      end
    end
  end
  self.container.menuCtl:RemoveAll()
end

function DialogPurchaseConfirmView:RefreshDetail()
  local des1 = self:FindGO("des_add"):GetComponent(UILabel)
  local detailBtn = self:FindGO("detailBtn")
  local detailBtnTxt = detailBtn:GetComponent(UILabel)
  if BranchMgr.IsKorea() or BranchMgr.IsSEA() or BranchMgr.IsNA() or BranchMgr.IsEU() then
    des1.text = ZhString.ShopConfirmDes1
    detailBtnTxt.text = ZhString.ShopConfirmBtnTxt
    detailBtn:SetActive(true)
    local ScrollView = self:FindGO("ScrollView"):GetComponent(UIScrollView)
    local detailTxt = self:FindGO("Text", ScrollView.gameObject):GetComponent(UILabel)
    detailTxt.text = ZhString.ShopConfirmDesTxT
    local detailTxtContainer = self:FindGO("detailTxtContainer")
    self:AddClickEvent(detailBtn, function(go)
      detailTxtContainer:SetActive(true)
      ScrollView:ResetPosition()
    end)
    local detailConfirmBtn = self:FindGO("detailConfirm", detailTxtContainer)
    self:AddClickEvent(detailConfirmBtn, function(go)
      detailTxtContainer:SetActive(false)
    end)
  else
    des1.text = nil
    detailBtnTxt.text = nil
    detailBtn:SetActive(false)
  end
end

function DialogPurchaseConfirmView:OnCHangeZ(data)
  local uipanels = Game.GameObjectUtil:GetAllComponentsInChildren(self.gameObject, UIPanel, true)
  for i = 1, #uipanels do
    local oriDepth = uipanels[i].depth
    oriDepth = oriDepth % 10
    uipanels[i].depth = data.depth + oriDepth
  end
end
