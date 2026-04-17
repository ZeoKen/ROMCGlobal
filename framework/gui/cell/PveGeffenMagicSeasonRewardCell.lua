PveGeffenMagicSeasonRewardCell = class("PveGeffenMagicSeasonRewardCell", BaseCell)

function PveGeffenMagicSeasonRewardCell:Init()
  self:FindObjs()
end

function PveGeffenMagicSeasonRewardCell:FindObjs()
  self.parentWidget = self.gameObject:GetComponent(UIWidget)
  self.titleLab = self:FindComponent("Title", UILabel)
  self.titleLab.text = ZhString.GeffenMagic_Season_Reward_Title
  self.rankLab = self:FindComponent("Rank", UILabel)
  self.rewardGrid = self:FindComponent("RewardGrid", UIGrid)
  self.myRankFlag = self:FindGO("MyRankFlag")
  self.rewardCtl = UIGridListCtrl.new(self.rewardGrid, PveDropItemCell, "PveDropItemCell")
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickRewardItem, self)
  self.redTip = self:FindGO("RedTip")
  self:AddCellClickEvent()
end

function PveGeffenMagicSeasonRewardCell:OnClickRewardItem(cellctl)
  local data = cellctl.data
  if data == PveDropItemCell.Empty then
    return
  end
  if cellctl and cellctl ~= self.chooseReward then
    local stick = cellctl.icon
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
      TipManager.Instance:ShowItemFloatTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-200, 0})
    end
    self.chooseReward = cellctl
  else
    self:CancelChooseReward()
  end
end

function PveGeffenMagicSeasonRewardCell:CancelChooseReward()
  self.chooseReward = nil
  self:ShowItemTip()
end

function PveGeffenMagicSeasonRewardCell:SetData(data)
  self.data = data
  self.hasReward = false
  if not data then
    return
  end
  local proxy = GeffenMagicWaveScoreProxy.Instance
  self.preRankPercent = proxy:GetPreRankPercent(data.index)
  self.rank = data.rank
  self.rankLab.text = string.format(ZhString.GeffenMagic_Season_Reward_Rank, self.preRankPercent, self.rank)
  self:SetReward(data.rewards)
  local myRankPercent = 0
  local hasRank = false
  if proxy:IsShowCurSeasonReward() then
    myRankPercent = proxy.rankPercent and proxy.rankPercent / 10 or 0
    hasRank = proxy.hasRank
  elseif proxy.lastSeasonHasRank then
    myRankPercent = proxy.lastSeasonRankPercent and proxy.lastSeasonRankPercent / 10 or 0
    hasRank = proxy.lastSeasonHasRank
  end
  local isMyRank = hasRank and 0 <= myRankPercent and myRankPercent >= self.preRankPercent and myRankPercent <= self.rank
  self.myRankFlag:SetActive(isMyRank == true and not proxy:IsShowCurSeasonReward())
  self.parentWidget.alpha = (isMyRank or proxy:IsShowCurSeasonReward()) and 1 or 0.5
  self.hasReward = proxy:LastSeasonHasReward() and not proxy:IsShowCurSeasonReward() and isMyRank
  self.redTip:SetActive(self.hasReward)
end

function PveGeffenMagicSeasonRewardCell:SetReward(rewardId)
  local rewardList = {}
  local rewardTeamids = ItemUtil.GetRewardItemIdsByTeamId(rewardId)
  if rewardTeamids then
    for _, data in pairs(rewardTeamids) do
      local item = PveDropItemData.new("PveDropReward", data.id)
      item.num = data.num
      item:SetType(PveDropItemData.Type.E_Normal)
      table.insert(rewardList, item)
    end
  end
  self.rewardCtl:ResetDatas(rewardList)
end
