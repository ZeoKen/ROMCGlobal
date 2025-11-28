autoImport("HomeBPDetailCell")
HomeFurnitureInfoPage = class("HomeFurnitureInfoPage", SubView)
HomeFurnitureInfoPage.texName_furnitureBG = "home_blueprint_bg_furniture"

function HomeFurnitureInfoPage:Init()
  self.detailDatas = {}
  self:InitUI()
  self:AddEvts()
  self:AddViewEvts()
end

function HomeFurnitureInfoPage:InitUI()
  self.gameObject = self:FindGO("FurnitureInfo")
  self.texFurniture = self:FindComponent("texFurniture", UITexture)
  self.texFurnitureBG = self:FindComponent("texFurnitureBG", UITexture)
  self.labFurnitureName = self:FindComponent("labFurnitureName", UILabel)
  local l_scrollView = self:FindGO("ScrollView")
  self.scrollInfos = l_scrollView:GetComponent(UIScrollView)
  self.listDetailInfos = UIGridListCtrl.new(self:FindComponent("detailTable", UITable, l_scrollView), HomeBPDetailCell, "HomeBPDetailCell")
end

function HomeFurnitureInfoPage:AddEvts()
  self:AddClickEvent(self:FindGO("btnReturn"), function(go)
    self.container:ShowBPDetail()
  end)
  self:AddClickEvent(self:FindGO("btnMakeFurniture"), function(go)
    if not self.furnitureData or not self.furnitureData.staticID then
      return
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.HomeTipPopUp,
      viewdata = self.furnitureData.staticID
    })
  end)
  self:AddDragEvent(self.texFurnitureBG.gameObject, function(go, delta)
    if self.furnitureModel then
      self.furnitureModel:RotateDelta(-delta.x)
    end
  end)
end

function HomeFurnitureInfoPage:AddViewEvts()
end

function HomeFurnitureInfoPage:ClickHelp()
  local helpData = Table_Help[self.viewdata.view.id]
  self:OpenHelpView(helpData)
end

function HomeFurnitureInfoPage:SetData(furnitureData)
  self.furnitureModel = nil
  self.furnitureData = furnitureData
  UIModelUtil.Instance:ResetTexture(self.texFurniture)
  if not furnitureData then
    return
  end
  local staticData = furnitureData.staticData
  local itemSData = Table_Item[staticData.id]
  UIModelUtil.Instance:SetFurnitureModelTexture(self.texFurniture, staticData.id, nil, function(obj)
    self.furnitureModel = obj
  end)
  UIModelUtil.Instance:SetCellTransparent(self.texFurniture)
  self.labFurnitureName.text = staticData.NameZh
  TableUtility.ArrayClear(self.detailDatas)
  local format = "[000000ff][ff6c1cff][%s][-]%s[-]"
  self.detailDatas[1] = string.format(format, ZhString.HomeBP_Type, "  " .. (itemSData and HomeProxy.Instance:GetSimpleItemTypeName(itemSData.Type) or ""))
  self.detailDatas[2] = string.format(format, ZhString.HomeBP_HaveNum, "  " .. furnitureData.haveNum)
  self.detailDatas[3] = string.format(format, ZhString.HomeBP_FurnitureScore, "  " .. staticData.HomeScore)
  self.detailDatas[4] = string.format(format, ZhString.HomeBP_FurnitureDesc, "\n" .. (itemSData and itemSData.Desc or ""))
  self.scrollInfos:ResetPosition()
  self.listDetailInfos:ResetDatas(self.detailDatas)
end

function HomeFurnitureInfoPage:OnEnter()
  HomeFurnitureInfoPage.super.OnEnter(self)
  PictureManager.Instance:SetHome(HomeFurnitureInfoPage.texName_furnitureBG, self.texFurnitureBG)
end

function HomeFurnitureInfoPage:OnExit()
  PictureManager.Instance:UnLoadHome(HomeFurnitureInfoPage.texName_furnitureBG, self.texFurnitureBG)
  UIModelUtil.Instance:ResetTexture(self.texFurniture)
  HomeFurnitureInfoPage.super.OnExit(self)
end
