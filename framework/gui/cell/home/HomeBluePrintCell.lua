HomeBluePrintCell = class("HomeBluePrintCell", BaseCell)
HomeBluePrintCell.ClickLike = "HomeBluePrintCell_ClickLike"

function HomeBluePrintCell:Init()
  HomeBluePrintCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function HomeBluePrintCell:FindObjs()
  self.objBtnLike = self:FindGO("btnLike")
  self.objLikeIcon = self:FindGO("iconLike", self.objBtnLike)
  self.labLikeNum = self:FindComponent("labLikeNum", UILabel)
  self.labProgress = self:FindComponent("labProgress", UILabel)
  self.labBPName = self:FindComponent("labBPName", UILabel)
  self.objInUse = self:FindGO("InUse")
  self.texBP = self:FindComponent("texBP", UITexture)
end

function HomeBluePrintCell:AddEvts()
  self:AddCellClickEvent()
  self:AddClickEvent(self.objBtnLike, function()
    self:PassEvent(HomeBluePrintCell.ClickLike, self)
  end)
end

function HomeBluePrintCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.bpData = HomeProxy.Instance:GetBluePrintData(data.id)
  self.labBPName.text = data.NameZh
  self.labProgress.text = string.format("%d/%d", self.bpData and self.bpData.haveFurnitureNum or 0, self.bpData and self.bpData.totalFurnitureNum or 0)
  self.objInUse:SetActive(false)
  PictureManager.Instance:SetHomeBluePrint(data.BPName, self.texBP)
  self:RefreshLikeStatus()
  local curBPData = HomeManager.Me():GetCurBluePrintData()
  self.isUsing = (curBPData and curBPData.staticID == data.id) == true
  self.objInUse:SetActive(self.isUsing)
end

function HomeBluePrintCell:RefreshLikeStatus()
  self.isLike = HomeProxy.Instance:IsILikeBluePrint(self.data.id)
  self.labLikeNum.text = HomeProxy.Instance:GetBluePrintLikeNum(self.data.id)
  self.objLikeIcon:SetActive(self.isLike == true)
end
