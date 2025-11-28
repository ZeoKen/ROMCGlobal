ChooseRouteView = class("ChooseRouteView", ContainerView)
ChooseRouteView.ViewType = UIViewType.DialogLayer
autoImport("Dialog_MenuData")
autoImport("ChooseRouteCell")

function ChooseRouteView:Init()
  self:InitView()
end

function ChooseRouteView:InitView()
  self.upperPart = self:FindGO("UpperTitle")
  self.titleLabel = self:FindComponent("Label", UILabel, self.upperPart)
  self.middlePart = self:FindGO("Middle")
  local grid = self:FindChild("Grid", self.middlePart):GetComponent(UIGrid)
  self.chooseRouteCtrl = UIGridListCtrl.new(grid, ChooseRouteCell, "ChooseRouteCell")
  self.chooseRouteCtrl:AddEventListener(MouseEvent.MouseClick, self.ClickMenuEvent, self)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.confirmDisabled = self:FindGO("ConfirmDisabled")
  self.exitBtn = self:FindGO("ExitBtn")
  self.confirmBtn.gameObject:SetActive(false)
  self.confirmDisabled.gameObject:SetActive(true)
  self:AddClickEvent(self.confirmBtn, function()
    self:CloseSelf()
  end)
  self:AddClickEvent(self.exitBtn, function()
    self:BackToLastNode()
  end)
  self.mask = self:FindGO("Mask")
end

function ChooseRouteView:OnEnter()
  ChooseRouteView.super.OnEnter(self)
  self:ResetViewData()
  self:UpdateViewData()
  self:UpdateShow()
end

function ChooseRouteView:OnExit()
  ChooseRouteView.super.OnExit(self)
  TimeTickManager.Me():ClearTick(self)
end

function ChooseRouteView:ResetViewData()
  self.defaultDialog = nil
  self.dialoglist = nil
  self.dialognpcs = nil
  self.iconlist = nil
  self.callback = nil
  self.callbackData = nil
  self.questId = nil
  if self.questParams then
    TableUtility.ArrayClear(self.questParams)
  else
    self.questParams = {}
  end
  self.optionid = nil
  self.exitOptionid = nil
  self.dialogInfo = nil
  self.dialogIndex = nil
  self.dialogend = false
  self.subViewId = nil
  self.optionWait = 0
  self.forceClickMenu = false
end

function ChooseRouteView:UpdateViewData()
  self.defaultDialog = self.viewdata.defaultDialog
  self.dialoglist = self.viewdata.dialoglist
  self.dialognpcs = self.viewdata.dialognpcs
  self.iconlist = self.viewdata.iconlist
  self.callback = self.viewdata.callback
  self.callbackData = self.viewdata.callbackData
  self.callbacQuestScope = self.viewdata.questScope
  self.questId = self.viewdata.questId
  self.forceNoChoose = self.viewdata.forceNoChoose or false
  self.dialogIndex = 1
  self.dialogInfo = {}
end

function ChooseRouteView:UpdateShow()
  helplog("UpdateShow")
  if self.dialoglist then
    self:UpdateDialoglst(self.dialoglist)
    if self.forceNoChoose then
      self.exitBtn:SetActive(false)
    end
  else
    helplog("no dialoglist")
  end
end

function ChooseRouteView:UpdateDialoglst(dialoglist)
  if 0 < #dialoglist then
    local dlst = {}
    for i = 1, #dialoglist do
      local dilg, data = dialoglist[i]
      if type(dilg) == "number" then
        data = DialogUtil.GetDialogData(dilg)
      elseif type(dilg) == "string" then
        data = {
          id = 0,
          Text = dilg,
          SubViewId = self.subViewId
        }
        if self.npcdata then
          data.Speaker = self.npcdata.id
        end
      elseif type(dilg) == "table" then
        data = {
          id = 0,
          Text = dilg.Text,
          ViceText = dilg.ViceText
        }
        if self.npcdata then
          data.Speaker = self.npcdata.id
        end
      end
      if data then
        table.insert(dlst, data)
      else
        errorLog(string.format("%s not config", dialoglist[i]))
      end
    end
    self.dialogInfo = dlst
    self:UpdateMainTitle()
  else
    self:CloseSelf()
  end
end

function ChooseRouteView:UpdateMainTitle()
  helplog("UpdateMainTitle")
  if #self.dialogInfo > 0 then
    self.nowDialogData = self.dialogInfo[self.dialogIndex]
    if self.nowDialogData then
      local context = self:GetDialogText(self.nowDialogData)
      self.titleLabel.text = context
      if self.nowDialogData.Option and self.nowDialogData.Option ~= "" then
        local optionConfig = StringUtil.AnalyzeDialogOptionConfig(OverSea.LangManager.Instance():GetLangByKey(self.nowDialogData.Option))
        if 0 < #optionConfig then
          self:UpdateRouteCtrl(optionConfig)
        end
      else
        helplog("无选项")
        self:UpdateRouteCtrl(nil)
      end
    end
  end
end

function ChooseRouteView:UpdateRouteCtrl(option)
  if not self.menuData then
    self.menuData = {}
  else
    TableUtility.ArrayClear(self.menuData)
  end
  if option then
    for i = 1, #option do
      if i == #option then
        self.exitOptionid = option[#option].id
      else
        local option_menuData = Dialog_MenuData.new()
        option_menuData:Set_ByOption(option[i])
        if self.iconlist then
          option_menuData:SetIcon_ByOption(self.iconlist[i])
        end
        table.insert(self.menuData, option_menuData)
      end
    end
  end
  self:UpdateMenuCtl()
  if self.forceNoChoose then
    TimeTickManager.Me():CreateOnceDelayTick(4000, function(owner, deltaTime)
      CameraAdditiveEffectManager.Me():StartShake(0.1, 0.2)
    end, self, 1)
    TimeTickManager.Me():CreateOnceDelayTick(2500, function(owner, deltaTime)
      FloatingPanel.Instance:FloatingMidEffectByFullPath(ResourcePathHelper.UIEffect(EffectMap.UI.ScreenBroken))
      self:PlayUISound(AudioMap.UI.GlassBroken)
    end, self, 2)
    TimeTickManager.Me():CreateOnceDelayTick(6000, function(owner, deltaTime)
      self:CloseSelf()
    end, self, 3)
  end
end

function ChooseRouteView:UpdateMenuCtl(menuData)
  menuData = menuData or self.menuData
  self.chooseRouteCtrl:ResetDatas(menuData)
  self.chooseRouteCtrl.layoutCtrl.repositionNow = true
end

function ChooseRouteView:ClickMenuEvent(cellCtl)
  local cellData = cellCtl.data
  if not cellData then
    return
  end
  if cellCtl ~= self.currentChoose then
    if self.currentChoose then
      self.currentChoose:setChoose(false)
    end
    self.currentChoose = cellCtl
    self.currentChoose:setChoose(true)
  else
    helplog("选择项相同")
  end
  self:DoMenuEvent(cellData)
end

function ChooseRouteView:DoMenuEvent(cellData)
  local menuType = cellData.menuType
  if menuType == Dialog_MenuData_Type.Option then
    self.optionid = cellData.optionid
    if not self.forceNoChoose then
      self.confirmBtn.gameObject:SetActive(true)
      self.confirmDisabled.gameObject:SetActive(false)
    else
      self.confirmBtn.gameObject:SetActive(false)
      self.confirmDisabled.gameObject:SetActive(true)
    end
  else
    helplog("menuType有误")
  end
end

function ChooseRouteView:MapEvent()
end

function ChooseRouteView:CloseSelf()
  helplog("CloseSelf")
  if self.callback ~= nil then
    helplog("callback not nil, option not nil")
    self.callback(self.callbackData, self.optionid, true, self.callbacQuestScope)
    self.callback = nil
    self.callbackData = nil
  end
  self.gameObject:SetActive(false)
  ChooseRouteView.super.CloseSelf(self)
end

function ChooseRouteView:BackToLastNode()
  if self.callback ~= nil then
    helplog("BackToLastNode callback not nil,to failjump", self.exitOptionid)
    self.callback(self.callbackData, self.exitOptionid, true, self.callbacQuestScope)
    self.callback = nil
    self.callbackData = nil
  end
  self.gameObject:SetActive(false)
  ChooseRouteView.super.CloseSelf(self)
end

function ChooseRouteView:GetDialogText(dialogData)
  local out_text = MsgParserProxy.Instance:TryParse(dialogData.Text or "")
  if dialogData.id == nil or _Dialog_ReplaceParam == nil then
    return out_text
  end
  local cfg = _Dialog_ReplaceParam[dialogData.id]
  if cfg == nil then
    return out_text
  end
  local params = {}
  for i = 1, #cfg do
    table.insert(params, self:ParseReplaceParam(cfg[i]))
  end
  return string.format(out_text, unpack(params))
end
