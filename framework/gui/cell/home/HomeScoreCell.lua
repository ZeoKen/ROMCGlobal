autoImport("BaseCell")
HomeScoreCell = class("HomeScoreCell", BaseCell)
local FurnitureFrameLvName = {
  [1] = "refine_bg_green",
  [2] = "refine_bg_blue",
  [3] = "refine_bg_purple",
  [4] = "refine_bg_orange",
  [5] = "refine_bg_red"
}

function HomeScoreCell:Init()
  self.isActive = true
  self:FindObjs()
  self:AddClickEvent(self.objHeadCell, function()
    self:OnClickHeadIcon()
  end)
end

function HomeScoreCell:FindObjs()
  self.widgetSelf = self.gameObject:GetComponent(UIWidget)
  self.labFurnitureInfo = self:FindComponent("labFurnitureInfo", UILabel)
  self.objHeadCell = self:FindGO("HeadCell")
  self.objHeadIcon = self:FindGO("HeadIcon", self.objHeadCell)
  self.sprHeadIcon = self.objHeadIcon:GetComponent(UISprite)
  self.sprHeadFrame = self:FindComponent("HeadFrame", UISprite)
  self.labScore = self:FindComponent("labScore", UILabel)
end

function HomeScoreCell:SetData(data)
  local haveData = data ~= nil
  self.data = data
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.labFurnitureInfo.text = data.NameZh
  self.labScore.text = string.format("+%s", data.HomeScore)
  self.widgetSelf.alpha = data.IsInvalidInHomeScorePage and 0.3 or 1
  self.staticID = data.id
  self.itemStaticData = Table_Item[data.id]
  local setSuc = IconManager:SetItemIcon(self.itemStaticData and self.itemStaticData.Icon, self.sprHeadIcon)
  setSuc = setSuc or IconManager:SetItemIcon("item_45001", self.sprHeadIcon)
  self.objHeadIcon:SetActive(setSuc)
  if setSuc then
    self.sprHeadIcon:MakePixelPerfect()
  end
  self.sprHeadFrame.spriteName = FurnitureFrameLvName[self.itemStaticData.Quality]
end

function HomeScoreCell:OnClickHeadIcon()
  self:PassEvent(MouseEvent.MouseClick, self)
end
