autoImport("BagItemCell")
WarbandRewardRankCell = class("WarbandRewardRankCell", BaseCell)
local fixed_TexBg = "pvp_bg_10"
local fixed_Tex = "12pvp_reward_bg_pic2"

function WarbandRewardRankCell:Init()
  self:FindObj()
end

function WarbandRewardRankCell:FindObj()
  self.root = self:FindGO("Root")
  self.indexLab = self:FindComponent("Index", UILabel)
  self.fixedTex = self:FindComponent("FixedTex", UITexture)
  self.bgTex = self:FindComponent("BgTex", UITexture)
  PictureManager.Instance:SetPVP(fixed_TexBg, self.fixedTex)
  PictureManager.Instance:SetPVP(fixed_Tex, self.bgTex)
  local grid = self:FindComponent("Grid", UIGrid)
  self.rewardCtl = UIGridListCtrl.new(grid, BagItemCell, "BagItemCell")
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.ClickItem, self)
end

function WarbandRewardRankCell:ClickItem(cellctl)
  if cellctl and cellctl ~= self.chooseItem then
    local data = cellctl.data
    local stick = cellctl.gameObject:GetComponentInChildren(UISprite)
    if data then
      local callback = function()
        self:CancelChoose()
      end
      local sdata = {
        itemdata = data,
        funcConfig = {},
        callback = callback,
        ignoreBounds = {
          cellctl.gameObject
        }
      }
      self:ShowItemTip(sdata, stick, NGUIUtil.AnchorSide.Left, {-250, 0})
    end
    self.chooseItem = cellctl
  else
    self:CancelChoose()
  end
end

function WarbandRewardRankCell:CancelChoose()
  self.chooseItem = nil
  self:ShowItemTip()
end

function WarbandRewardRankCell:SetData(data)
  self.data = data
  if not data then
    self.root:SetActive(false)
    return
  end
  local itemData = {}
  for i = 1, #data.rewardIDs do
    local item = ItemData.new("warbandreward", data.rewardIDs[i][1])
    item:SetItemNum(data.rewardIDs[i][2])
    itemData[#itemData + 1] = item
  end
  self.rewardCtl:ResetDatas(itemData)
  self.indexLab.text = nil == data.endRank and string.format(ZhString.Warband_RewardIndex1, data.beginRank) or string.format(ZhString.Warband_RewardIndex2, data.beginRank, data.endRank)
  self.root:SetActive(true)
end
