autoImport("HomeBPInfoPage")
autoImport("HomeFurnitureInfoPage")
autoImport("BPFurnitureCell")
HomeBPDetailView = class("HomeBPDetailView", ContainerView)
HomeBPDetailView.ViewType = UIViewType.NormalLayer
HomeBPDetailView.TexName = {
  bgUp = "home_blueprint_bg_paper2_upper",
  bgDown = "home_blueprint_bg_paper2_lower",
  bgLeft = "home_blueprint_bg_paper2_left",
  bgRight = "home_blueprint_bg_paper2_right"
}
local vec_arrowEulerOpen = LuaVector3(0, 0, 180)
local vec_arrowEulerClose = LuaVector3.Zero()

function HomeBPDetailView:Init()
  self.furnitureDatas = {}
  self.tabFurnitureDatas = {}
  self:InitUI()
  self:AddListenEvt()
end

function HomeBPDetailView:InitUI()
  self.homeBPInfoPage = self:AddSubView("HomeBPInfoPage", HomeBPInfoPage)
  self.homeFurnitureInfoPage = self:AddSubView("HomeFurnitureInfoPage", HomeFurnitureInfoPage)
  self.objItemTabs = self:FindGO("ItemTabs")
  self.popItemTabs = self.objItemTabs:GetComponent(UIPopupList)
  self.tsfPopArrow = self:FindGO("Arrow", self.objItemTabs).transform
  self.objItemTabsSelect = self:FindGO("ItemTabsBgSelect", self.objItemTabs)
  self.listFurnitures = WrapListCtrl.new(self:FindGO("wrapFurniture"), BPFurnitureCell, "BPFurnitureCell", WrapListCtrl_Dir.Vertical, 2, 233, true)
  self:InitPopList()
end

function HomeBPDetailView:InitPopList()
  self.popItemTabs:Clear()
  local configs = GameConfig.Home.FurnitureSeries
  if not configs then
    return
  end
  local single, firstContent
  for i = 1, #configs do
    single = configs[i]
    if single.seriesType > -1 then
      self.popItemTabs:AddItem(single.name, single)
      firstContent = firstContent or single
    end
  end
  if firstContent then
    self.popItemTabs.value = firstContent.name
    self.curSeriesType = firstContent.seriesType
  end
end

function HomeBPDetailView:AddListenEvt()
  self.listFurnitures:AddEventListener(MouseEvent.MouseClick, self.ClickFurnitureCell, self)
  self:AddClickEvent(self:FindGO("btnClose"), function()
    self:CloseSelf()
  end)
  EventDelegate.Add(self.popItemTabs.onChange, function()
    if self.selectTabData ~= self.popItemTabs.data then
      self.selectTabData = self.popItemTabs.data
      self:OnSelectTab(self.selectTabData)
    end
  end)
end

function HomeBPDetailView:SetBPData(bluePrintData)
  TableUtility.TableClear(self.furnitureDatas)
  TableUtility.TableClear(self.tabFurnitureDatas)
  self.staticData = bluePrintData.staticData
  self.bluePrintData = bluePrintData
  if self.bluePrintData then
    for staticID, data in pairs(self.bluePrintData.furnitureInfoMap) do
      self.furnitureDatas[#self.furnitureDatas + 1] = data
    end
  end
  self.homeBPInfoPage:SetData(bluePrintData)
  self:UpdateBPInfos()
end

function HomeBPDetailView:OnSelectTab(tabData)
  if tabData.seriesType == self.curSeriesType then
    return
  end
  self.curSeriesType = tabData.seriesType
  if tabData.seriesType == HomeProxy.FurnitureSpecialCatagory.All then
    self:UpdateBPInfos()
    return
  end
  TableUtility.TableClear(self.tabFurnitureDatas)
  local single
  for i = 1, #self.furnitureDatas do
    single = self.furnitureDatas[i]
    if single.staticData.Catagory & tabData.seriesType > 0 then
      self.tabFurnitureDatas[#self.tabFurnitureDatas + 1] = single
    end
  end
  self:UpdateBPInfos(self.tabFurnitureDatas)
end

function HomeBPDetailView:UpdateBPInfos(datas)
  self:ShowBPDetail()
  self.listFurnitures:ResetDatas(datas or self.furnitureDatas)
  self.listFurnitures:ResetPosition()
end

function HomeBPDetailView:ClickFurnitureCell(cell)
  if not cell.data then
    redlog("此cell没有数据！")
    return
  end
  if self.curSelectCell then
    if self.curSelectCell.data and self.curSelectCell.data.staticID == self.curSelectData.staticID then
      if self.curSelectCell.data.staticID == cell.data.staticID then
        self:ShowBPDetail()
        return
      end
      self.curSelectCell:Select(false)
    else
      self.curSelectData.isSelect = false
    end
  end
  self.homeBPInfoPage.gameObject:SetActive(false)
  self.homeFurnitureInfoPage.gameObject:SetActive(true)
  self.curSelectCell = cell
  self.curSelectData = cell.data
  cell:Select(true)
  self.homeFurnitureInfoPage:SetData(cell.data)
end

function HomeBPDetailView:ShowBPDetail()
  if self.curSelectCell then
    if self.curSelectCell.data.staticID == self.curSelectData.staticID then
      self.curSelectCell:Select(false)
    else
      self.curSelectData.isSelect = false
    end
  end
  self.curSelectCell = nil
  self.curSelectData = nil
  self.homeBPInfoPage.gameObject:SetActive(true)
  self.homeFurnitureInfoPage.gameObject:SetActive(false)
end

function HomeBPDetailView:CheckPopListSelect()
  if self.popItemTabs.isOpen == self.isPopOpen then
    return
  end
  self.isPopOpen = self.popItemTabs.isOpen
  self.objItemTabsSelect:SetActive(self.isPopOpen == true)
  self.tsfPopArrow.localEulerAngles = self.isPopOpen and vec_arrowEulerOpen or vec_arrowEulerClose
end

function HomeBPDetailView:OnEnter()
  HomeBPDetailView.super.OnEnter(self)
  PictureManager.Instance:SetHome(HomeBPDetailView.TexName.bgUp, self:FindComponent("texUp", UITexture))
  PictureManager.Instance:SetHome(HomeBPDetailView.TexName.bgDown, self:FindComponent("texDown", UITexture))
  PictureManager.Instance:SetHome(HomeBPDetailView.TexName.bgLeft, self:FindComponent("texLeft", UITexture))
  PictureManager.Instance:SetHome(HomeBPDetailView.TexName.bgRight, self:FindComponent("texRight", UITexture))
  self:SetBPData(self.viewdata and self.viewdata.viewdata)
  TimeTickManager.Me():CreateTick(0, 100, self.CheckPopListSelect, self, 1)
end

function HomeBPDetailView:OnExit()
  for k, v in pairs(HomeBPDetailView.TexName) do
    PictureManager.Instance:UnLoadHome(v)
  end
  if self.curSelectData then
    self.curSelectData.isSelect = false
  end
  TimeTickManager.Me():ClearTick(self)
  HomeBPDetailView.super.OnExit(self)
end

function HomeBPDetailView:OnDestroy()
  self.popItemTabs = nil
  self.listFurnitures:Destroy()
  HomeBPDetailView.super.OnDestroy(self)
end
