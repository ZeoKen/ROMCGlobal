local baseCell = autoImport("BaseCell")
TriplePlayerPvpWaittingCell = class("TriplePlayerPvpWaittingCell", baseCell)
local tempVector3 = LuaVector3.Zero()

function TriplePlayerPvpWaittingCell:Init()
  TriplePlayerPvpWaittingCell.super.Init(self)
  self:FindObjs()
end

function TriplePlayerPvpWaittingCell:FindObjs()
  self.emptyRoot = self:FindGO("EmptyRoot")
end

function TriplePlayerPvpWaittingCell:InitHead()
  if self.portraitCell then
    return
  end
  self.portraitCell = PlayerFaceCell.new(self.gameObject)
  self.portraitCell:SetMinDepth(1)
end

function TriplePlayerPvpWaittingCell:SetData(data)
  self.data = data
  if not data or TriplePlayerPvpProxy.EmptyHead == data then
    self.emptyRoot:SetActive(true)
    if self.portraitCell then
      self.portraitCell.gameObject:SetActive(false)
    end
    return
  end
  self:InitHead()
  self.emptyRoot:SetActive(false)
  self.portraitCell.gameObject:SetActive(true)
  self.portraitCell:SetData(data)
end

function TriplePlayerPvpWaittingCell:OnCellDestroy()
  if self.portraitCell then
    self.portraitCell:RemoveIconEvent()
  end
end
