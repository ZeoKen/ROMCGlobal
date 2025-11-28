InviteCodePopOverSeaView = class("InviteCodePopOverSeaView", BaseView)
InviteCodePopOverSeaView.ViewType = UIViewType.PopUpLayer
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

function InviteCodePopOverSeaView:Init()
  self:FindOBJ()
  self:AddEvents()
  self:InitData()
end

function InviteCodePopOverSeaView:FindOBJ()
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

function InviteCodePopOverSeaView:AddEvents()
  self:AddClickEvent(self.acButton, function()
    self:ReciveBtnClick()
  end)
  self:AddClickEvent(self.mask, function()
    self:CloseSelf()
  end)
end

function InviteCodePopOverSeaView:InitData()
  local configData = ItemUtil.GetRewardItemIdsByTeamId(self.viewdata.viewdata.BindReward)
  self.data = configData
  if configData then
    local rewardData = {}
    for k, v in pairs(configData) do
      local ItemData = ItemData.new("PlayerRefluxReward", v.id)
      ItemData.num = v.num
      table.insert(rewardData, ItemData)
    end
    self.recordGrid:ResetDatas(rewardData)
  end
end

function InviteCodePopOverSeaView:ReciveBtnClick()
  helplog("============ CallNewPartnerBindCmd ===================")
  helplog("code === ", self.inputLable.value)
  ServiceActivityCmdProxy.Instance:CallNewPartnerBindCmd(self.inputLable.value)
  self:CloseSelf()
end

function InviteCodePopOverSeaView:ClickPreviewRewardItem(cellctl)
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

function InviteCodePopOverSeaView:CancelChoosePreview()
  self.choosePreview = nil
  self:ShowItemTip()
  self.mask:SetActive(true)
end

function InviteCodePopOverSeaView:HandleQueryUserInfo(note)
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
