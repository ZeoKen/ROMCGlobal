autoImport("ItemCell")
LotteryCell = class("LotteryCell", ItemCell)
LotteryCell.ClickEvent = "LotteryCell_ClickEvent"

function LotteryCell:Init()
  self.itemContainer = self:FindGO("ItemContainer")
  local obj = self:LoadPreferb("cell/ItemCell", self.itemContainer)
  obj.transform.localPosition = LuaVector3.Zero()
  LotteryCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function LotteryCell:FindObjs()
  self.gotFlag = self:FindGO("Get")
  self.curBatch = self:FindComponent("CurBatch", UISprite)
end

function LotteryCell:AddEvts()
  self:AddClickEvent(self.itemContainer, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:AddClickEvent(self.gameObject, function()
    self:PassEvent(LotteryCell.ClickEvent, self)
  end)
end

function LotteryCell:SetData(data)
  self.gameObject:SetActive(data ~= nil)
  self.data = data
  if not data then
    return
  end
  self.realItemID = self.data:GetRealItemID()
  self:UpdateGotFlag()
  self:UpdateCurBranch()
  LotteryCell.super.SetData(self, data:GetItemData())
  if self.nameLab then
    UIUtil.WrapLabel(self.nameLab)
  end
  self:HideBgSp()
end

function LotteryCell:UpdateDressLab()
  if not self.dressLab then
    return
  end
  self:Show(self.dressLab)
  if self.realItemID then
    self.dressLab.text = FunctionLottery.Me():GetDressingDesc(self.realItemID)
  else
    self.dressLab.text = ""
  end
end

function LotteryCell:UpdateGotFlag()
  if not self.gotFlag then
    return
  end
  self.gotFlag:SetActive(self.data and self.data.CheckGoodsGot and self.data:CheckGoodsGot() or false)
end

function LotteryCell:UpdateCurBranch()
  if not self.curBatch then
    return
  end
  self.curBatch.gameObject:SetActive(self.data and self.data.isCurBatch == 1)
end
