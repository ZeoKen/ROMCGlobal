local scaleRatio
local _SpColor = {
  UnChoose = LuaColor.New(1.0, 1.0, 1.0, 0.7),
  Choose = LuaColor.New(0.803921568627451, 0.9098039215686274, 1.0, 0.7)
}
TransferClassCell = class("TransferClassCell", BaseCell)

function TransferClassCell:ctor(obj)
  TransferClassCell.super.ctor(self, obj)
  self:FindSP()
  self:AddCellClickEvent()
end

function TransferClassCell:FindSP()
  self.sp = self:FindComponent("Sprite", GradientUISprite)
  self.choosen = self:FindGO("Choosen")
  self.unchoosen = self:FindGO("Unchoosen")
end

function TransferClassCell:SetData(id)
  self.data = id
  self.gameObject:SetActive(id ~= nil)
  if not id then
    return
  end
  IconManager:SetNewProfessionIcon(Table_Class[id].icon, self.sp)
  self:UpdateChoose()
end

function TransferClassCell:SetChoose(id)
  self.chooseid = id
  self:UpdateChoose()
end

function TransferClassCell:UpdateChoose()
  local choosen = self.data and self.chooseid == self.data
  self.unchoosen:SetActive(not choosen)
  if choosen then
    self.choosen:SetActive(true)
    ColorUtil.WhiteUIWidget(self.sp)
    scaleRatio = 1.2
  else
    self.choosen:SetActive(false)
    self.sp.color = _SpColor.UnChoose
    scaleRatio = 1
  end
  LuaGameObject.SetLocalScaleGO(self.sp.gameObject, scaleRatio, scaleRatio, scaleRatio)
end
