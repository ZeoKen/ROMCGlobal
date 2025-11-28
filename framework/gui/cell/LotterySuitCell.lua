autoImport("LotteryCell")
LotterySuitCell = class("LotterySuitCell", LotteryCell)

function LotterySuitCell:FindObjs()
  LotterySuitCell.super.FindObjs(self)
  self.forbidden = self:FindGO("Forbidden")
  self.choosen = self:FindGO("Choosen")
end

function LotterySuitCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  self.data = data
  if not data then
    return
  end
  self.realItemID = self.data.itemid
  self:UpdateGotFlag()
  self:UpdateCurBranch()
  LotterySuitCell.super.super.SetData(self, data:GetServerItemData())
  self:HideBgSp()
  self.data = data
  self:UpdateChoose()
end

function LotterySuitCell:SetForbidden(var)
  self.forbidden:SetActive(var)
end

function LotterySuitCell:SetChoose(id)
  self.chooseid = id
  self:UpdateChoose()
end

function LotterySuitCell:UpdateChoose()
  if self.data and self.data.goodsID == self.chooseid then
    self:Show(self.choosen)
  else
    self:Hide(self.choosen)
  end
end

function LotterySuitCell:UpdateGotFlag()
  self.gotFlag:SetActive(self.data:CheckGoodsGot(true))
end
