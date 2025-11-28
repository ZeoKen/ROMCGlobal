PCHotKeySetView = class("PCHotKeySetView", BaseView)
PCHotKeySetView.ViewType = UIViewType.NormalLayer
autoImport("PCHotKeySetViewCell")
local _ButtonLabelRed = Color(0.49019607843137253, 0.027450980392156862, 0.01568627450980392, 1)
local _TipLabelNormal = "474747"
local TIP_SELECT_POS = LuaVector3.Zero()

function PCHotKeySetView:Init()
  self:AddViewEvt()
  self:InitData()
  self:FindObj()
  self:AddButtonEvt()
  self:InitView()
end

function PCHotKeySetView:AddViewEvt()
end

function PCHotKeySetView:InitData()
end

function PCHotKeySetView:InitView()
  self.hotkeyDatas = Game.HotKeyManager:GenerateAllHotKeyInfo()
  self.cellCtl:ResetDatas(self.hotkeyDatas, true)
  self.confirmCell = PCHotKeyConfirmCell.new(self:FindGO("ConfirmCell"))
end

function PCHotKeySetView:FindObj()
  local recommendPos = self:FindGO("recommendPos")
  self.scrollView = self:FindComponent("ScrollView", UIScrollView, recommendPos)
  local wrapConfig = {
    wrapObj = self:FindGO("ItemWrap", recommendPos),
    pfbNum = 8,
    cellName = "PCHotKeySetViewCell",
    control = PCHotKeySetViewCell
  }
  self.cellCtl = WrapCellHelper.new(wrapConfig)
  self.cellCtl:AddEventListener(MouseEvent.MouseClick, self.OnHotKeyCellClick, self)
  self.clearBtnSprite = self:FindComponent("ClearBtn", UISprite)
  self.clearBtnLabel = self:FindComponent("Label", UILabel, self.clearBtnSprite.gameObject)
  self.clearBtnBoxCollider = self.clearBtnSprite.gameObject:GetComponent(BoxCollider)
  local tipLevelSwitch = self:FindGO("TipLevelSwitch")
  self.closeTipBtn = self:FindGO("close", tipLevelSwitch)
  self.closeTipLabel = self.closeTipBtn:GetComponent(UILabel)
  self.simpleTipBtn = self:FindGO("simple", tipLevelSwitch)
  self.simpleTipLabel = self.simpleTipBtn:GetComponent(UILabel)
  self.allTipBtn = self:FindGO("all", tipLevelSwitch)
  self.allTipLabel = self.allTipBtn:GetComponent(UILabel)
  self.tipSelectGO = self:FindGO("selectBg", tipLevelSwitch)
end

function PCHotKeySetView:AddButtonEvt()
  self:AddButtonEvent("DefaultBtn", function()
    self:DoRestoreToDefault()
  end)
  self:AddButtonEvent("ClearBtn", function()
    self:DoClear()
  end)
  self:AddButtonEvent("SaveBtn", function()
    self:DoSave()
  end)
  self:AddClickEvent(self.closeTipBtn, function()
    self:OnCloseTipBtnClick()
  end)
  self:AddClickEvent(self.simpleTipBtn, function()
    self:OnSimpleTipBtnClick()
  end)
  self:AddClickEvent(self.allTipBtn, function()
    self:OnAllTipBtnClick()
  end)
end

function PCHotKeySetView:DoRestoreToDefault()
  self.confirmCell:ShowConfirm(ZhString.PCHotKey_ResetHint, function()
    Game.HotKeyManager:ResetCustomConfigToDefault()
    Game.HotKeyManager:RefreshAllHotKeyInfo(self.hotkeyDatas)
    self:ClearHotKeySelect()
    Game.HotKeyTipManager:ResetHotKeyTips()
  end, nil)
end

function PCHotKeySetView:DoClear()
  local select = self:GetHotKeySelect()
  if select == nil then
    Game.HotKeyManager:ExitCheckKeyMode()
    self:ClearHotKeySelect()
    return
  end
  Game.HotKeyManager:ExitCheckKeyMode()
  Game.HotKeyManager:SetHotKeyCustom(select.id, KeyCode.None, select.select)
  Game.HotKeyManager:RefreshAllHotKeyInfo(self.hotkeyDatas)
  self:ClearHotKeySelect()
  Game.HotKeyTipManager:SetHotKeyTip(select.id)
end

function PCHotKeySetView:DoSave()
  Game.HotKeyManager:SaveHotKeyCustomConfig()
  Game.HotKeyManager:ApplyCustomConfig()
  Game.HotKeyTipManager:SaveTipLevel()
end

function PCHotKeySetView:RefreshClearBtn(enable)
  if enable then
    self.clearBtnBoxCollider.enabled = true
    self.clearBtnSprite.spriteName = "com_btn_0"
    self.clearBtnLabel.effectColor = _ButtonLabelRed
  else
    self.clearBtnBoxCollider.enabled = false
    self.clearBtnSprite.spriteName = "com_btn_13"
    self.clearBtnLabel.effectColor = ColorUtil.NGUIGray
  end
end

function PCHotKeySetView:RefreshSaveBtn(enable)
end

function PCHotKeySetView:OnEnter()
  PCHotKeySetView.super.OnEnter(self)
  HotKeyManager.InEditMode = true
  self:RefreshClearBtn(false)
  self:SetTipLevel()
end

function PCHotKeySetView:OnExit()
  self:DoSave()
  Game.HotKeyManager:ExitCheckKeyMode()
  HotKeyManager.InEditMode = false
  PCHotKeySetView.super.OnExit(self)
end

function PCHotKeySetView:OnHotKeyCellClick(info)
  local cell = info and info[1]
  local index = info and info[2]
  if not cell or not index then
    return
  end
  local notSelected = cell.data.select == 0
  for _, v in pairs(self.hotkeyDatas) do
    v.select = 0
  end
  if notSelected then
    cell.data.select = index
    self.cellCtl:ResetDatas(self.hotkeyDatas, false)
    Game.HotKeyManager:EnterCheckKeyMode(function(key1, key2)
      self:ReceiveCheckKeyModeResult(key1, key2)
    end)
    self:RefreshClearBtn(not cell.isNone)
  else
    Game.HotKeyManager:ExitCheckKeyMode()
    self:ClearHotKeySelect()
  end
end

function PCHotKeySetView:GetHotKeySelect()
  for _, v in pairs(self.hotkeyDatas) do
    if v.select > 0 then
      return v
    end
  end
end

function PCHotKeySetView:ClearHotKeySelect()
  for _, v in pairs(self.hotkeyDatas) do
    v.select = 0
  end
  self.cellCtl:ResetDatas(self.hotkeyDatas, false)
  self:RefreshClearBtn(false)
end

function PCHotKeySetView:ReceiveCheckKeyModeResult(key1, key2)
  if key1 == nil or key1 == KeyCode.None or key1 == KeyCode.Escape then
    Game.HotKeyManager:ExitCheckKeyMode()
    self:ClearHotKeySelect()
    return
  end
  local select = self:GetHotKeySelect()
  if select == nil then
    Game.HotKeyManager:ExitCheckKeyMode()
    self:ClearHotKeySelect()
    return
  end
  local hotKey = HotKeyManager.GetKeyCodeName(key1)
  local displayConf = Game.WindowsHotKeyDisplay[hotKey]
  if not displayConf then
    return
  end
  if displayConf.Invalid == 1 then
    local display = not StringUtil.IsEmpty(displayConf.Display) and displayConf.Display or hotKey
    MsgManager.ShowMsgByID(43469, display)
    return
  end
  Game.HotKeyManager:ExitCheckKeyMode()
  local exist, existKey, existIndex
  for _, v in pairs(self.hotkeyDatas) do
    if v.hotKeyCode == key1 then
      exist = v
      existKey = v.hotKey
      existIndex = 1
      break
    elseif v.hotKeyCode2 == key1 then
      exist = v
      existKey = v.hotKey2
      existIndex = 2
      break
    end
  end
  if exist and exist.id ~= select.id then
    local displayName = Game.WindowsHotKeyDisplay[existKey] and Game.WindowsHotKeyDisplay[existKey].Display
    displayName = not StringUtil.IsEmpty(displayName) and displayName or existKey
    local confirmText = string.format(ZhString.PCHotKey_ReplaceHint, displayName, exist.name)
    self.confirmCell:ShowConfirm(confirmText, function()
      Game.HotKeyManager:SetHotKeyCustom(exist.id, KeyCode.None, existIndex)
      Game.HotKeyManager:SetHotKeyCustom(select.id, key1, select.select)
      Game.HotKeyManager:RefreshAllHotKeyInfo(self.hotkeyDatas)
      self:ClearHotKeySelect()
      Game.HotKeyTipManager:SetHotKeyTip(exist.id)
      Game.HotKeyTipManager:SetHotKeyTip(select.id)
    end, function()
      Game.HotKeyManager:EnterCheckKeyMode(function(key1, key2)
        self:ReceiveCheckKeyModeResult(key1, key2)
      end)
    end)
    return
  else
    Game.HotKeyManager:SetHotKeyCustom(select.id, key1, select.select)
    Game.HotKeyManager:RefreshAllHotKeyInfo(self.hotkeyDatas)
    self:ClearHotKeySelect()
    Game.HotKeyTipManager:SetHotKeyTip(select.id)
  end
end

function PCHotKeySetView:SetTipLevel()
  local _, c = ColorUtil.TryParseHexString(_TipLabelNormal)
  local obj
  local level = Game.HotKeyTipManager:GetTipLevel()
  if level == HotKeyTipManager.TipLevel.ALL then
    ColorUtil.WhiteUIWidget(self.allTipLabel)
    self.simpleTipLabel.color = c
    self.closeTipLabel.color = c
    obj = self.allTipBtn
  elseif level == HotKeyTipManager.TipLevel.SIMPLE then
    ColorUtil.WhiteUIWidget(self.simpleTipLabel)
    self.closeTipLabel.color = c
    self.allTipLabel.color = c
    obj = self.simpleTipBtn
  elseif level == HotKeyTipManager.TipLevel.CLOSE then
    ColorUtil.WhiteUIWidget(self.closeTipLabel)
    self.simpleTipLabel.color = c
    self.allTipLabel.color = c
    obj = self.closeTipBtn
  end
  if obj then
    LuaVector3.Better_Set(TIP_SELECT_POS, LuaGameObject.GetLocalPositionGO(obj))
    TweenPosition.Begin(self.tipSelectGO, 0.1, TIP_SELECT_POS)
  end
end

function PCHotKeySetView:OnCloseTipBtnClick()
  Game.HotKeyTipManager:SetTipLevel(HotKeyTipManager.TipLevel.CLOSE)
  self:SetTipLevel()
end

function PCHotKeySetView:OnSimpleTipBtnClick()
  Game.HotKeyTipManager:SetTipLevel(HotKeyTipManager.TipLevel.SIMPLE)
  self:SetTipLevel()
end

function PCHotKeySetView:OnAllTipBtnClick()
  Game.HotKeyTipManager:SetTipLevel(HotKeyTipManager.TipLevel.ALL)
  self:SetTipLevel()
end

PCHotKeyConfirmCell = class("PCHotKeyConfirmCell", BaseCell)

function PCHotKeyConfirmCell:Init()
  self.label = self:FindGO("ContentLabel"):GetComponent(UILabel)
  self.confirmBtn = self:FindGO("ConfirmBtn")
  self.cancelBtn = self:FindGO("CancelBtn")
  self.closeBtn = self:FindGO("CloseButton")
  self:AddClickEvent(self.confirmBtn, function()
    if self.confirmCall then
      self.confirmCall()
      self.confirmCall = nil
    end
    self:Hide()
  end)
  self:AddClickEvent(self.cancelBtn, function()
    if self.cancelCall then
      self.cancelCall()
      self.cancelCall = nil
    end
    self:Hide()
  end)
  self:AddClickEvent(self.closeBtn, function()
    if self.cancelCall then
      self.cancelCall()
      self.cancelCall = nil
    end
    self:Hide()
  end)
end

function PCHotKeyConfirmCell:ShowConfirm(content, confirmCall, cancelCall)
  self.label.text = content
  self.confirmCall = confirmCall
  self.cancelCall = cancelCall
  self:Show()
end
