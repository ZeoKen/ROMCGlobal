autoImport("AstralRewardItemCell")
AstralLevelTargetCell = class("AstralLevelTargetCell", BaseCell)
local BgName = "ui_DMJ_Bg7"

function AstralLevelTargetCell:Init()
  self:FindObjs()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function AstralLevelTargetCell:FindObjs()
  self.bg = self:FindComponent("Bg", UITexture)
  self.titleLabel = self:FindComponent("Title", UILabel)
  local grid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardListCtrl = UIGridListCtrl.new(grid, AstralRewardItemCell, "AstralRewardItemCell")
  self.rewardListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnRewardClick, self)
  self.getBtn = self:FindGO("GetBtn")
  self:AddClickEvent(self.getBtn, function()
    self:OnGetBtnClick()
  end)
  self.receivedCheck = self:FindGO("Check")
  self.lockedTip = self:FindGO("LockedTip")
end

function AstralLevelTargetCell:SetData(data)
  PictureManager.Instance:SetAstralTexture(BgName, self.bg)
  self.data = data
  if data then
    self.titleLabel.text = string.format(ZhString.Pve_Astral_TargetPassNum, data.targetNum)
    local rewards = ItemUtil.GetRewardItemIdsByTeamId(data.reward)
    local datas = {}
    for i = 1, #rewards do
      local itemData = ItemData.new("", rewards[i].id)
      itemData.num = rewards[i].num
      datas[#datas + 1] = itemData
    end
    self.rewardListCtrl:ResetDatas(datas)
    local curPassNum = AstralProxy.Instance:GetCurPassNum()
    local isReceived = AstralProxy.Instance:IsRewardReceived()
    local canReceive = curPassNum >= data.targetNum and not isReceived or false
    self.getBtn:SetActive(canReceive)
    self.receivedCheck:SetActive(isReceived)
    self.lockedTip:SetActive(curPassNum < data.targetNum)
  end
end

function AstralLevelTargetCell:OnGetBtnClick()
  if self.data then
    ServiceMessCCmdProxy.Instance:CallAstralRewardMessCCmd(nil, self.data.targetNum)
  end
end

function AstralLevelTargetCell:OnRewardClick(cell)
  if cell.data then
    self.tipData.itemdata = cell.data
    self:ShowItemTip(self.tipData, cell.bg, NGUIUtil.AnchorSide.Up, {200, 0})
  end
end

function AstralLevelTargetCell:OnCellDestroy()
  PictureManager.Instance:UnloadAstralTexture(BgName, self.bg)
end
