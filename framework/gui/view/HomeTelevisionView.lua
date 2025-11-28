autoImport("HomeTelevisionCell")
HomeTelevisionView = class("HomeTelevisionView", BaseView)
HomeTelevisionView.ViewType = UIViewType.PopUpLayer
local tempArr = {}

function HomeTelevisionView:Init()
  self:FindObjs()
  self:InitView()
  self:AddEvents()
end

function HomeTelevisionView:FindObjs()
  self.bgTex = self:FindComponent("Bg", UITexture)
  self.titleLabel = self:FindComponent("TitleLabel", UILabel)
  self.cgTex = self:FindComponent("CgTexture", UITexture)
  self.grid = self:FindComponent("Grid", UIGrid)
end

function HomeTelevisionView:InitView()
  self.listCtrl = UIGridListCtrl.new(self.grid, HomeTelevisionCell, "HomeTelevisionCell")
  self.listCtrl:AddEventListener(MouseEvent.MouseClick, self.OnClickCell, self)
  self.listCtrl:AddEventListener(HomeEvent.WatchTV, self.OnWatch, self)
  TableUtility.ArrayClear(tempArr)
  for _, data in pairs(Table_Video) do
    if data.IsShow and data.IsShow > 0 then
      TableUtility.ArrayPushBack(tempArr, data)
    end
  end
  self.listCtrl:ResetDatas(tempArr)
end

function HomeTelevisionView:AddEvents()
  self:AddListenEvt(HomeEvent.ExitHome, self.CloseSelf)
end

function HomeTelevisionView:OnEnter()
  HomeTelevisionView.super.OnEnter(self)
  local cells = self.listCtrl:GetCells()
  if cells and next(cells) then
    self:OnClickCell(cells[1])
  end
end

function HomeTelevisionView:OnExit()
  self:TryUnloadCgTex()
  HomeTelevisionView.super.OnExit(self)
end

function HomeTelevisionView:OnClickCell(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  if self.chooseId == data.id then
    return
  end
  self:ChooseCell(data.id)
  self:SetCgTex(data.CgPic)
  self.titleLabel.text = data.NameZh
end

function HomeTelevisionView:OnWatch(cellCtl)
  local data = cellCtl and cellCtl.data
  if not data then
    return
  end
  self:PlayCg(data.id)
end

function HomeTelevisionView:ChooseCell(id)
  self.chooseId = id
  local cells = self.listCtrl:GetCells()
  for _, cell in pairs(cells) do
    cell:SetChoose(id)
  end
end

function HomeTelevisionView:SetCgTex(cgTexName)
  self:TryUnloadCgTex()
  self.cgTexName = cgTexName
  PictureManager.Instance:SetHome(self.cgTexName, self.cgTex)
end

function HomeTelevisionView:TryUnloadCgTex()
  if self.cgTexName and self.cgTexName ~= "" then
    PictureManager.Instance:UnLoadHome(self.cgTexName, self.cgTex)
  end
end

function HomeTelevisionView:PlayCg(videoID)
  FunctionVideoStorage.Me():PlayVideoByID(videoID)
end
