PlayerRefluxPopView = class("PlayerRefluxPopView", BaseView)
PlayerRefluxPopView.ViewType = UIViewType.PopUpLayer
autoImport("PlayerRefluxBindCell")
local panelConfig = {
  inviteCode = {
    bghight = 420,
    btnYPos = -129,
    titleText = ZhString.PlayerRefluxView_InviteCodeTitle
  },
  notInviteCode = {
    bghight = 356,
    btnYPos = -70,
    titleText = ZhString.PlayerRefluxView_NotInviteCodeTitle
  }
}
local tempVector3 = LuaVector3.Zero()
local getlocalPos = LuaGameObject.GetLocalPosition
local funkey = {"ShowReflux"}
local tipData = {}

function PlayerRefluxPopView:Init()
  self:FindOBJ()
  self:AddEvents()
  self:InitData()
end

function PlayerRefluxPopView:FindOBJ()
  self.mask = self:FindGO("mask")
  self.bgWidget = self:FindComponent("TipBG", UIWidget)
  self.titleLable = self:FindComponent("title", UILabel)
  self.clickUrl = self:FindComponent("title", UILabelClickUrl)
  local grid = self:FindComponent("recordGrid", UIGrid)
  self.recordGrid = UIGridListCtrl.new(grid, PlayerRefluxBindCell, "PlayerRefluxBindCell")
  self.recordGrid:AddEventListener(MouseEvent.MouseClick, self.ClickPreviewRewardItem, self)
  self.inpuRoot = self:FindGO("imputRoot")
  self.inputLable = self:FindComponent("imputbg", UIInput, self.inpuRoot)
  self.acButton = self:FindGO("acButton")
  self.acbtnTransform = self.acButton.transform
  self.bg = self:FindComponent("TipBG", UISprite)
end

function PlayerRefluxPopView:AddEvents()
  self:AddClickEvent(self.acButton, function()
    self:ReciveBtnClick()
  end)
  self:AddClickEvent(self.mask, function()
    if self.data.inviteCode == true then
      self:CloseSelf()
    end
  end)
  
  function self.clickUrl.callback(url)
    if url ~= nil and self.data.playerId ~= nil then
      ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.data.playerId)
    end
  end
  
  self:AddListenEvt(ServiceEvent.SessionSocialityQueryUserInfoCmd, self.HandleQueryUserInfo)
end

function PlayerRefluxPopView:InitData()
  self.data = self.viewdata.data
  local configData
  if self.data.inviteCode then
    self.inpuRoot:SetActive(true)
    self.titleLable.text = panelConfig.inviteCode.titleText
    configData = self.data.configData.BindReward
  else
    LuaVector3.Better_Set(tempVector3, getlocalPos(self.acbtnTransform))
    tempVector3[2] = panelConfig.notInviteCode.btnYPos
    self.acbtnTransform.localPosition = tempVector3
    self.inpuRoot:SetActive(false)
    self.bgWidget.height = panelConfig.notInviteCode.bghight
    if self.data.playerName and self.data.playerId then
      self.titleLable.text = string.format(panelConfig.notInviteCode.titleText, self.data.playerId, self.data.playerName)
    end
    configData = self.data.configData.InvitationReward
  end
  if configData then
    local rewardData = {}
    for k, v in pairs(configData) do
      local ItemData = ItemData.new("PlayerRefluxReward", v[1])
      ItemData.num = v[2]
      table.insert(rewardData, ItemData)
    end
    self.recordGrid:ResetDatas(rewardData)
  end
end

function PlayerRefluxPopView:ReciveBtnClick()
  if self.data.inviteCode then
    helplog("============call Bind User Cmd ===================")
    helplog("code === ", self.inputLable.value)
    PlayerRefluxProxy.Instance:CallUserInviteBindUserCmd(self.inputLable.value)
  else
    helplog("============call Bind User Award Cmd ===================")
    PlayerRefluxProxy.Instance:CallUserInviteInviteAwardCmd()
  end
  self:CloseSelf()
end

function PlayerRefluxPopView:ClickPreviewRewardItem(cellctl)
  if cellctl and cellctl ~= self.choosePreview then
    self.mask:SetActive(false)
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChoosePreview()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Right, {200, 0})
    end
    self.choosePreview = cellctl
  else
    self:CancelChoosePreview()
  end
end

function PlayerRefluxPopView:CancelChoosePreview()
  self.choosePreview = nil
  self:ShowItemTip()
  self.mask:SetActive(true)
end

function PlayerRefluxPopView:HandleQueryUserInfo(note)
  local data = note.body
  if data then
    if self.playerTipData == nil then
      self.playerTipData = PlayerTipData.new()
    end
    self.playerTipData:SetBySocialData(data.data)
    local _FunctionPlayerTip = FunctionPlayerTip.Me()
    _FunctionPlayerTip:CloseTip()
    local playerTip = _FunctionPlayerTip:GetPlayerTip(self.bg, NGUIUtil.AnchorSide.Center, {-174, 100})
    tipData.playerData = self.playerTipData
    tipData.funckeys = funkey
    playerTip:SetData(tipData)
  end
end
