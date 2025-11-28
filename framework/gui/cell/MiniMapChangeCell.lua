local BaseCell = autoImport("BaseCell")
MiniMapChangeCell = class("MiniMapChangeCell", BaseCell)
MiniMapChangeCell.StatusColor = {
  [1] = LuaColor.New(0.5568627450980392, 1.0, 0.33725490196078434, 1),
  [2] = LuaColor.New(1.0, 0.8509803921568627, 0.25098039215686274, 1),
  [3] = LuaColor.New(0.8666666666666667, 0.3254901960784314, 0.21568627450980393, 1),
  [4] = LuaColor.New(1, 1, 1, 1)
}

function MiniMapChangeCell:Init()
  self.name = self:FindGO("Name"):GetComponent(UILabel)
  self.cloneName = self:FindGO("CloneName"):GetComponent(UILabel)
  self.clone = self:FindGO("Clone"):GetComponent(UISprite)
  self:AddCellClickEvent()
end

function MiniMapChangeCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data then
    local mapData = Table_Map[data.id]
    if mapData ~= nil and mapData.CloneMap == data.id then
      self.name.text = ZhString.MainViewMiniMap_LeaveCloneMap
      self.cloneName.gameObject:SetActive(false)
    else
      self.name.text = ""
      self.clone.color = MiniMapChangeCell.StatusColor[data.status] or MiniMapChangeCell.StatusColor[4]
      self.cloneName.text = data.name
      self.cloneName.gameObject:SetActive(true)
    end
  end
end
