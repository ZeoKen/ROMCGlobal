autoImport("BaseCell")
NoviceBattlePassTaskCell = class("NoviceBattlePassTaskCell", BaseCell)

function NoviceBattlePassTaskCell:SetBPType(bPType)
  self.bPType = bPType
  if self.id then
    if self.bPType == 2 then
      local info = NoviceBattlePassProxy.Instance:GetReturnBPTaskData(self.id)
      self:SetCellData(info, Table_ReturnBattlePassTask[self.id], 185)
    else
      local info = NoviceBattlePassProxy.Instance:GetNoviceBPTaskData(self.id)
      self:SetCellData(info, Table_NoviceBattlePassTask[self.id], 185)
    end
  end
end

function NoviceBattlePassTaskCell:CallTargetRewardUserCmd(id)
  ServiceNUserProxy.Instance:CallNoviceTargetRewardUserCmd(id)
end

function NoviceBattlePassTaskCell:Init()
  NoviceBattlePassTaskCell.super.Init(self)
  self:FindObjs()
end

function NoviceBattlePassTaskCell:FindObjs()
  self.descLabel = self:FindComponent("desc", UILabel)
  self.progressLabel = self:FindComponent("progress", UILabel)
  self.receiveBtn = self:FindGO("receiveBtn")
  self.receiveBtn_Collider = self.receiveBtn:GetComponent(BoxCollider)
  self:AddClickEvent(self.receiveBtn, function()
    self:CallTargetRewardUserCmd(self.id)
  end)
  self.gotoBtn = self:FindGO("gotoBtn")
  self:AddClickEvent(self.gotoBtn, function()
    self:PassEvent(NoviceBattlePassEvent.OnGotoBtnClick, self)
  end)
  self.receivedCheck = self:FindGO("receivedCheck")
  local rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.rewardList = UIGridListCtrl.new(rewardGrid, BagItemCell, "BagItemCell")
  local rewardPanel = self:FindComponent("RewardScrollView", UIPanel)
  local upPanel = UIUtil.GetComponentInParents(self.gameObject, UIPanel)
  if upPanel and rewardPanel then
    rewardPanel.depth = upPanel.depth + 1
  end
end

function NoviceBattlePassTaskCell:SetData(data)
  self.id = data
end

function NoviceBattlePassTaskCell:SetCellData(info, staticData, itemId)
  if staticData then
    self.descLabel.text = staticData.Desc
    local targetNum = staticData.TargetNum
    local progress = info.progress
    if staticData.TargetType == 103 then
      targetNum = math.floor(targetNum / 60)
      progress = math.floor(progress / 60)
    end
    self.progressLabel.text = progress .. "/" .. targetNum
    local datas = ReusableTable.CreateArray()
    if staticData.Reward then
      for i = 1, #staticData.Reward do
        self:SetReward(staticData.Reward[i], datas)
      end
    end
    if staticData.Exp then
      local itemData = ItemData.new("Reward", itemId)
      if itemData then
        itemData:SetItemNum(staticData.Exp)
      end
      datas[#datas + 1] = itemData
    end
    self.rewardList:ResetDatas(datas)
    ReusableTable.DestroyAndClearArray(datas)
    if (not staticData.Goto or not staticData.Goto[1]) and (not staticData.Message or not staticData.Message[1]) then
      self:SetTaskState(info.state, true)
      return
    end
  end
  self:SetTaskState(info.state)
end

function NoviceBattlePassTaskCell:SetTaskState(state, hideGoTo)
  if state == SceneUser2_pb.ENOVICE_TARGET_FINISH then
    self:EnableReceiveBtn(true)
    self.receiveBtn:SetActive(true)
    self.gotoBtn:SetActive(false)
    self.receivedCheck:SetActive(false)
  elseif state == SceneUser2_pb.ENOVICE_TARGET_GO then
    if hideGoTo then
      self.gotoBtn:SetActive(false)
      self.receiveBtn:SetActive(true)
      self:EnableReceiveBtn(false)
    else
      self.gotoBtn:SetActive(true)
      self.receiveBtn:SetActive(false)
    end
    self.receivedCheck:SetActive(false)
  elseif state == SceneUser2_pb.ENOVICE_TARGET_REWARDED then
    self.receiveBtn:SetActive(false)
    self.gotoBtn:SetActive(false)
    self.receivedCheck:SetActive(true)
  else
    self.receiveBtn:SetActive(false)
    self.gotoBtn:SetActive(false)
    self.receivedCheck:SetActive(false)
  end
end

function NoviceBattlePassTaskCell:EnableReceiveBtn(b)
  if b then
    self.receiveBtn_Collider.enabled = true
    self:SetTextureWhite(self.receiveBtn, LuaGeometry.GetTempColor(0.7686274509803922, 0.5254901960784314, 0, 1))
  else
    self.receiveBtn_Collider.enabled = false
    self:SetTextureGrey(self.receiveBtn)
  end
end

function NoviceBattlePassTaskCell:SetReward(rewardId, list)
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
          if single.refinelv and itemData:IsEquip() then
            itemData.equipInfo:SetRefine(single.refinelv)
          end
          list[#list + 1] = itemData
        end
      end
    end
  end
end
