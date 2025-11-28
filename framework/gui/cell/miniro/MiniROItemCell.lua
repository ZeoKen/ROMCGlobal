autoImport("BaseRoundRewardCell")
MiniROItemCell = class("MiniROItemCell", BaseRoundRewardCell)

function MiniROItemCell:SetData(data)
  self.data = data
  if not data then
    return
  end
  self.tipStick = data[4]
  local listRewardIds = data[3]
  for k, rewardId in pairs(listRewardIds) do
    local listItemId = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
    if not listItemId or TableUtil.TableIsEmpty(listItemId) then
      return
    end
    local itemCell
    for k, v in pairs(listItemId) do
      local item = ItemData.new("Reward", v.id)
      if k <= #self.listItem then
        itemCell = self.listItem[k]
        itemCell:Show()
        item.num = v.num
        if v.refinelv and item:IsEquip() then
          item.equipInfo:SetRefine(v.refinelv)
        end
        itemCell:SetData(item)
      end
    end
  end
  self.txtTitle.text = data[2]
  self.objReceived:SetActive(data[1] <= MiniROProxy.Instance:GetCurCompleteTurns())
end

function MiniROItemCell:SetView(parentView)
  self.parentView = parentView
end
