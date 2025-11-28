autoImport("AstralDestinyGraphPointCell")
AstralDestinyGraphSeasonCell = class("AstralDestinyGraphSeasonCell", BaseCell)
local BgPrefix = "Greatsecret_starrysky_s"

function AstralDestinyGraphSeasonCell:ctor(parent, prefabName)
  local go = self:LoadPrefab(parent, prefabName)
  AstralDestinyGraphSeasonCell.super.ctor(self, go)
end

function AstralDestinyGraphSeasonCell:LoadPrefab(parent, prefabName)
  local go = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("AstralDestinyGraph/" .. prefabName))
  if not go then
    error("can not find cellpfb" .. prefabName)
  end
  go.transform:SetParent(parent.transform, false)
  LuaGameObject.SetLocalPositionGO(go, 0, 0, 0)
  return go
end

function AstralDestinyGraphSeasonCell:Init()
  self:FindObjs()
end

function AstralDestinyGraphSeasonCell:FindObjs()
  self.bgTex = self.gameObject:GetComponent(UITexture)
  self.seasonLabel = self:FindComponent("Season", UILabel)
  self.openGO = self:FindGO("Open")
  self.points = {}
  self.pointList = {}
  for i = 1, 10 do
    local pointParent = self:FindGO("P_" .. i)
    self.points[i] = pointParent
  end
end

function AstralDestinyGraphSeasonCell:SetData(data)
  self.data = data
  if data then
    local season = (data.season - 1) % 12 + 1
    PictureManager.Instance:SetAstralTexture(BgPrefix .. season, self.bgTex)
    self.seasonLabel.text = "S" .. data.season
    local curSeason = AstralProxy.Instance:GetSeason()
    self.openGO:SetActive(data.season == curSeason and not AstralProxy.Instance:IsSeasonEnd())
    for i = 1, 10 do
      local parent = self.points[i]
      local pointData = data.points[i]
      local cell = self.pointList[i]
      if not cell then
        cell = self:CreatePointCell(pointData, parent)
        self.pointList[i] = cell
      end
      cell:SetData(pointData)
    end
  end
end

function AstralDestinyGraphSeasonCell:CreatePointCell(pointData, parent)
  local prefabName = pointData:IsSpecialPoint() and "AstralDestinyGraphPointCell_L" or "AstralDestinyGraphPointCell"
  local cell = AstralDestinyGraphPointCell.new(parent, prefabName)
  cell:AddEventListener(MouseEvent.MouseClick, self.OnClickPointCell, self)
  return cell
end

function AstralDestinyGraphSeasonCell:OnClickPointCell(cell)
  self:PassEvent(MouseEvent.MouseClick, cell)
end

function AstralDestinyGraphSeasonCell:SetCellSelectState(cell)
  cell:SetSelect(true)
  for i = 1, #self.pointList do
    if self.pointList[i] ~= cell then
      self.pointList[i]:SetSelect(false)
    end
  end
end

function AstralDestinyGraphSeasonCell:SetPointSelectState(point)
  local cell = self.pointList[point]
  if cell then
    self:SetCellSelectState(cell)
  end
  return cell
end

function AstralDestinyGraphSeasonCell:ClearPointSelectState()
  for i = 1, #self.pointList do
    self.pointList[i]:SetSelect(false)
  end
end

function AstralDestinyGraphSeasonCell:PlayPointEffect(index)
  local cell = self.pointList[index]
  if cell then
    cell:PlayEffect()
  end
end

function AstralDestinyGraphSeasonCell:OnCellDestroy()
  if self.data then
    PictureManager.Instance:UnloadAstralTexture(BgPrefix .. self.data.season, self.bgTex)
  end
  TableUtility.ArrayClearByDeleter(self.pointList, function(v)
    GameObject.DestroyImmediate(v.gameObject)
  end)
end
