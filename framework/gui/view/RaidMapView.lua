RaidMapView = class("RaidMapView", SubView)
RaidMapView.ViewType = UIViewType.NormalLayer
autoImport("RaidMapBtnCell")
local raidpic = GameConfig.Thanatos_Public.ThanatosRaidMap
local cellName = "GUI/v1/cell/RaidMapLabel"

function RaidMapView:Init()
  self:FindObj()
  local btnlist = {}
  for i = 1, #raidpic do
    local entry = {}
    entry.id = i
    entry.name = raidpic[i].name
    table.insert(btnlist, entry)
  end
  self.btnCtr:ResetDatas(btnlist)
end

function RaidMapView:FindObj()
  self.mapTexture = self:FindGO("MapTexture"):GetComponent(UITexture)
  local btnGrid = self:FindGO("BtnGrid"):GetComponent(UIGrid)
  self.btnCtr = UIGridListCtrl.new(btnGrid, RaidMapBtnCell, "RaidMapBtnCell")
  self.btnCtr:AddEventListener(MouseEvent.MouseClick, self.ClickRaidMap, self)
end

function RaidMapView:ClickRaidMap(cell)
  if cell and cell.data then
    local index = cell.data.id
    local cell = self.btnCtr:GetCells()
    for i = 1, #cell do
      cell[i]:SetTog(index == cell[i].data.id)
    end
    if self.golist then
      for i = 1, #self.golist do
        GameObject.DestroyImmediate(self.golist[i])
      end
    end
    self.currentpic = raidpic[index].pic
    PictureManager.Instance:SetUI(self.currentpic, self.mapTexture)
    self:SetMapContext(index)
  end
end

function RaidMapView:OnEnter()
  local showdata = {}
  showdata.data = {}
  showdata.data.id = 1
  self:ClickRaidMap(showdata)
end

function RaidMapView:SetMapContext(configIndex)
  if not self.mapTexture then
    return
  end
  local display = raidpic[configIndex].display
  self.golist = {}
  if display then
    local single = {}
    local pos = {}
    local label
    for i = 1, #display do
      single = display[i]
      local go = Game.AssetManager_UI:CreateAsset(cellName, self.mapTexture)
      table.insert(self.golist, go)
      pos = single.pos
      go.transform.localPosition = LuaGeometry.GetTempVector3(pos[1], pos[2], pos[3])
      if go then
        label = go:GetComponent(UILabel)
        label.text = single.text
        label.fontSize = single.fontSize
        label.width = single.width
        label.height = single.height
        if single.pivot then
          if single.pivot == 0 then
            label.pivot = UIWidget.Pivot.Center
          elseif single.pivot == 1 then
            label.pivot = UIWidget.Pivot.Left
          end
        end
      end
    end
  end
end

function RaidMapView:OnExit()
  PictureManager.Instance:UnLoadUI(self.currentpic, self.mapTexture)
  if self.golist then
    for i = 1, #self.golist do
      GameObject.DestroyImmediate(self.golist[i])
    end
  end
end
