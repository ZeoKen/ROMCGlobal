local _TextureName = "Novicecopy_mubiao_tips_bg"
PveAchievementCell = class("PveAchievementCell", BaseCell)

function PveAchievementCell:Init()
  PveAchievementCell.super.Init(self)
  self:FindObj()
  self:AddEvt()
end

function PveAchievementCell:FindObj()
  self.descLab = self:FindComponent("DescLab", UILabel)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.texture = self:FindComponent("Texture", UITexture)
  self.extraDesc = self:FindComponent("ExtraDesc", UILabel)
  self.lockDesc = self:FindComponent("LockDesc", UILabel)
  self.lockDesc.text = ZhString.Pve_Achievement_Lock
  self.receiveBtn = self:FindGO("receiveBtn"):GetComponent(UIButton)
  self.receiveLabel = self:FindGO("receiveLabel"):GetComponent(UILabel)
  self.receiveLabel.text = ZhString.Pve_Reward
  self:AddClickEvent(self.receiveBtn.gameObject, function()
    if self.data then
      ServiceFuBenCmdProxy.Instance:CallPickupPveRaidAchieveFubenCmd(self.data.GroupId, self.data.id)
    end
  end)
  self.status = self:FindGO("status")
end

function PveAchievementCell:AddEvt()
  self.gridCtrl = UIGridListCtrl.new(self.grid, ItemCell, "ItemCell")
  self.gridCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickItemCell, self)
end

function PveAchievementCell:SetData(data)
  if not data or not Table_PveRaidAchievement[data] then
    return
  end
  self.data = Table_PveRaidAchievement[data]
  PictureManager.Instance:SetUI(_TextureName, self.texture)
  local done = PveEntranceProxy.Instance:CheckDone(self.data.GroupId, self.data.id)
  if done then
    self:Hide(self.receiveBtn.gameObject)
    self:Show(self.status)
    self:Hide(self.lockDesc)
  elseif done == false then
    self:Show(self.receiveBtn.gameObject)
    self:Hide(self.status)
    self:Hide(self.lockDesc)
  else
    self:Hide(self.receiveBtn.gameObject)
    self:Show(self.lockDesc)
    self:Hide(self.status)
  end
  self.descLab.text = self.data.desc
  if self.data.extraReward and self.data.extraReward == 1 then
    self.extraDesc.text = self.data.extraDesc or ""
    self.gridCtrl:ResetDatas({})
  else
    local staticReward = ItemUtil.GetRewardItemIdsByTeamId(self.data.rewardid) or {}
    local rewardData = {}
    local itemData
    for i = 1, #staticReward do
      local itemData = ItemData.new("PveAchievementReward", staticReward[i].id)
      itemData:SetItemNum(staticReward[i].num)
      if staticReward[i].refinelv and itemData:IsEquip() then
        itemData.equipInfo:SetRefine(staticReward[i].refinelv)
      end
      rewardData[#rewardData + 1] = itemData
    end
    self.gridCtrl:ResetDatas(rewardData)
    self.extraDesc.text = ""
  end
end

function PveAchievementCell:OnClickItemCell(cellctl)
  if cellctl and cellctl ~= self.chooseReward then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponent(UIWidget)
    if data then
      local callback = function()
        self:CancelChooseReward()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function PveAchievementCell:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function PveAchievementCell:OnRemove()
  PictureManager.Instance:UnLoadUI(_TextureName, self.texture)
end
