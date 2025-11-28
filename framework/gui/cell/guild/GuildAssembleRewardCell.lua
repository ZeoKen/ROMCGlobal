autoImport("BaseCell")
GuildAssembleRewardCell = class("GuildAssembleRewardCell", BaseCell)
local decorationName = "pvp_bg_10"

function GuildAssembleRewardCell:Init()
  self:FindObjs()
end

function GuildAssembleRewardCell:FindObjs()
  self.bg = self.gameObject:GetComponent(UISprite)
  self.decoration = self:FindComponent("decoration", UITexture)
  self.targetLabel = self:FindComponent("target", UILabel)
  local rewardGrid = self:FindComponent("Grid", UIGrid)
  self.rewardList = UIGridListCtrl.new(rewardGrid, BagItemCell, "GuildAssembleRewardItemCell")
  self.rewardList:AddEventListener(MouseEvent.MouseClick, self.HandleClickReward, self)
  self.getBtn = self:FindGO("getBtn")
  self:AddClickEvent(self.getBtn, function()
    self:PassEvent(GuildEvent.GetAssembleReward, self)
  end)
  self.getBtnGrey = self:FindGO("getBtnGrey")
  self.check = self:FindGO("check")
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function GuildAssembleRewardCell:SetData(data)
  PictureManager.Instance:SetPVP(decorationName, self.decoration)
  if data then
    self.data = data
    local curAssembleNum = GuildProxy.Instance:GetGuildAssembleCompleteNum()
    local targetNum = data.Amount
    local str
    if curAssembleNum < targetNum then
      str = string.format(ZhString.GuildAssembleCompleteNum, curAssembleNum, targetNum)
    else
      str = string.format(ZhString.GuildAssembleCompleteNumFull, targetNum, targetNum)
    end
    self.targetLabel.text = str
    if curAssembleNum < targetNum then
      self.getBtn:SetActive(false)
      self.getBtnGrey:SetActive(true)
      self.check:SetActive(false)
      self.bg.alpha = 1
    else
      local isReceived = GuildProxy.Instance:IsAssembleRewardReceived(data.id)
      if isReceived then
        self.getBtn:SetActive(false)
        self.getBtnGrey:SetActive(false)
        self.check:SetActive(true)
        self.bg.alpha = 0.4
      else
        self.getBtn:SetActive(true)
        self.getBtnGrey:SetActive(false)
        self.check:SetActive(false)
        self.bg.alpha = 1
      end
    end
    local datas = ReusableTable.CreateArray()
    self:SetReward(data.RewardId, datas)
    self.rewardList:ResetDatas(datas)
    ReusableTable.DestroyAndClearArray(datas)
  end
end

function GuildAssembleRewardCell:SetReward(rewardId, list)
  local itemIds = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if itemIds then
    for i = 1, #itemIds do
      local single = itemIds[i]
      local hasAdd = false
      local item = TableUtility.ArrayFindByPredicate(list, function(item, data)
        return item.id == data.id
      end, single)
      if item then
        item.num = item.num + single.num
        hasAdd = true
      end
      if not hasAdd then
        local itemData = ItemData.new("Reward", single.id)
        if itemData then
          itemData:SetItemNum(single.num)
          list[#list + 1] = itemData
        end
      end
    end
  end
end

function GuildAssembleRewardCell:HandleClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    self.tipData.itemdata = cellCtrl.data
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {0, 0})
  end
end

function GuildAssembleRewardCell:OnDestroy()
  PictureManager.Instance:UnLoadPVP(decorationName, self.decoration)
end
