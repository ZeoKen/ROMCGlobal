local itemCellCount = 4
local tempCellVector3 = LuaVector3.Zero()
local itemCellPos = {
  [1] = -97.9,
  [2] = -0.9,
  [3] = 96.5,
  [4] = 193.0
}
autoImport("PveDropItemCell")
autoImport("BaseRoundRewardCell")
ServantRoundRewardCell = class("ServantRoundRewardCell", BaseRoundRewardCell)

function ServantRoundRewardCell:InitCellPath()
  self.cellPath = "cell/PveDropItemCell"
end

function ServantRoundRewardCell:InitItemList()
  local itemCell
  for i = 1, itemCellCount do
    local obj = self:LoadPreferb(self.cellPath, self.gameObject)
    tempCellVector3[1] = itemCellPos[i]
    obj.transform.localPosition = tempCellVector3
    itemCell = PveDropItemCell.new(obj)
    itemCell:Hide()
    self:AddClickEvent(obj, function(go)
      self:OnClickRewardCell(self.listItem[i])
    end)
    self.listItem[#self.listItem + 1] = itemCell
  end
end

function ServantRoundRewardCell:OnClickRewardCell(cellctl)
  if cellctl and cellctl ~= self.chooseReward then
    local data = cellctl.data
    local stick = cellctl:GetBgSprite()
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          self.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {290, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function ServantRoundRewardCell:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function ServantRoundRewardCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.tipStick = self.data[4]
  local rewards = self.data[3]
  for i = 1, #self.listItem do
    if rewards[i] then
      self.listItem[i]:Show()
      self.listItem[i]:SetData(rewards[i])
    else
      self.listItem[i]:Hide()
    end
  end
  self:UpdateTitle()
  self:UpdateFinishState()
end

function ServantRoundRewardCell:UpdateTitle()
  if not self.txtTitle then
    return
  end
  self.txtTitle.text = self.data[2]
end

function ServantRoundRewardCell:UpdateFinishState()
  if not self.objReceived then
    return
  end
  self.objReceived:SetActive(self.data[1] <= BattleTimeDataProxy.Instance:GetCurRewardRound())
end
