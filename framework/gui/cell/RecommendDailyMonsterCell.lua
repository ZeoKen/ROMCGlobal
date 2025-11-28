autoImport("PveDropItemCell")
local _DiffMode = ServantRecommendProxy.E_Monster_Difficulty
local _ModelStr = {
  [_DiffMode.Recommend] = {
    ZhString.RecommendDailyMonster_Mode_Recommend,
    "0A8FED"
  },
  [_DiffMode.Easy] = {
    ZhString.RecommendDailyMonster_Mode_Easy,
    "19950C"
  },
  [_DiffMode.Hard] = {
    ZhString.RecommendDailyMonster_Mode_Hard,
    "C12A08"
  }
}
local _BgTextureName = "hangup_bg_01"
RecommendDailyMonsterCell = class("RecommendDailyMonsterCell", BaseCell)

function RecommendDailyMonsterCell:Init()
  self:InitHead()
  self:FindObjs()
end

function RecommendDailyMonsterCell:FindObjs()
  self.root = self:FindGO("Root")
  self.bgTexture = self:FindComponent("BgTexture", UITexture, self.root)
  PictureManager.Instance:SetUI(_BgTextureName, self.bgTexture)
  self.modeLab = self:FindComponent("ModeLab", UILabel, self.root)
  self.levelLab = self:FindComponent("LevelLab", UILabel, self.root)
  self.nameLab = self:FindComponent("NameLab", UILabel, self.root)
  self.goBtn = self:FindGO("GoBtn", self.root)
  self:AddClickEvent(self.goBtn, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  local rewardGrid = self:FindComponent("RewardGrid", UIGrid, self.root)
  self.rewardCtl = UIGridListCtrl.new(rewardGrid, PveDropItemCell, "PveDropItemCell")
  self.rewardCtl:AddEventListener(MouseEvent.MouseClick, self.OnClickReward, self)
end

function RecommendDailyMonsterCell:OnClickReward(cellCtrl)
  if cellCtrl and cellCtrl.data then
    local item_data = cellCtrl.data
    self.tipData = self.tipData or {}
    self.tipData.itemdata = item_data
    self.tipData.funcConfig = {}
    self:ShowItemTip(self.tipData, cellCtrl.icon, NGUIUtil.AnchorSide.Left, {-230, 0})
  end
end

function RecommendDailyMonsterCell:SetData(data)
  self.data = data
  self.root:SetActive(nil ~= data)
  if not data then
    return
  end
  self.modeLab.text = _ModelStr[data.diffMode][1]
  local color = _ModelStr[data.diffMode][2]
  if not StringUtil.IsEmpty(color) then
    local _, c = ColorUtil.TryParseHexString(color)
    if _ then
      self.modeLab.color = c
    end
  end
  self.levelLab.text = string.format(ZhString.Pve_Lv, data:GetLevel())
  self.nameLab.text = data:GetName()
  self:SetHead()
  self.rewardCtl:ResetDatas(data:GetRewardData())
end

function RecommendDailyMonsterCell:InitHead()
  local headContainer = self:FindGO("HeadContainer")
  self.headIconCell = HeadIconCell.new()
  self.headIconCell:CreateSelf(headContainer)
  self.headIconCell:SetMinDepth(1)
  self.headIconCell:HideFrame()
end

function RecommendDailyMonsterCell:SetHead()
  local headData = self.data:GetHeadData()
  if not headData then
    return
  end
  self.headIconCell:SetSimpleIcon(headData.iconData.icon, headData.iconData.frameType)
  local simpleIcon = self.headIconCell.simpleIcon
  self.headIconCell:MakePixelPerfect(simpleIcon)
  self.headIconCell:SetClickWidthHeight(simpleIcon.width, simpleIcon.height)
  self.headIconCell:AddDragScrollview()
end

function RecommendDailyMonsterCell:OnCellDestroy()
  self.rewardCtl:Destroy()
  if self.headIconCell then
    self.headIconCell:OnRemove()
  end
  PictureManager.Instance:UnLoadUI(_BgTextureName, self.bgTexture)
end
