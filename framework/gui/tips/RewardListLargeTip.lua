autoImport("RewardListTip")
RewardListLargeTip = class("RewardListLargeTip", RewardListTip)
RewardListLargeTip.MaxWidth = 300

function RewardListLargeTip:ctor(prefabName, stick, side, offset)
  RewardListLargeTip.super.ctor(self, prefabName, stick.gameObject)
end

function RewardListLargeTip:InitTip()
  RewardListLargeTip.super.InitTip(self)
  self.tip = self:FindGO("Label"):GetComponent(UILabel)
end

function RewardListLargeTip:SetData(data)
  local itemList = ItemUtil.GetRewardItemIdsByTeamId(data.rewardid)
  local itemDataList = {}
  if itemList and 0 < #itemList then
    for i = 1, #itemList do
      local itemInfo = itemList[i]
      local tempItem = ItemData.new("", itemInfo.id)
      tempItem.num = itemInfo.num
      itemDataList[#itemDataList + 1] = tempItem
    end
    self.listControllerOfItems:ResetDatas(itemDataList)
    local cells = self.listControllerOfItems:GetCells()
    for i = 1, #cells do
      cells[i].gameObject.transform.localScale = LuaGeometry.GetTempVector3(0.75, 0.75, 0.75)
    end
    self.scrollPanel.depth = self.panel.depth + 10
  end
  if data.name then
    self.tip.text = string.format(ZhString.QuestDetailTip_WorldQuestReward, data.name)
  end
end
