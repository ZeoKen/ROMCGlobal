local BaseCell = autoImport("BaseCell")
MiniGameCell = class("MiniGameCell", BaseCell)

function MiniGameCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function MiniGameCell:FindObjs()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.gameBg = self:FindGO("gameBg"):GetComponent(UITexture)
  self.chooseSymbol = self:FindGO("Choose")
end

function MiniGameCell:SetData(data)
  self.data = data
  if data then
    self.id = data.id
    self.name.text = data.name
    PictureManager.Instance:SetUI(data.pic, self.gameBg)
  end
end

function MiniGameCell:UpdateChoose(b)
  self.chooseSymbol:SetActive(b)
end

function MiniGameCell:OnDestroy()
  PictureManager.Instance:UnLoadPVP(self.data.pic, self.gameBg)
end
