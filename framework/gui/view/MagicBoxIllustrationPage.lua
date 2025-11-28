MagicBoxIllustrationPage = class("MagicBoxIllustrationPage", SubView)
autoImport("EquipIllustrationCell")
local FilterConfig = GameConfig.EquipExtractionFilter
local prefabPath = ResourcePathHelper.UIView("MagicBoxIllustrationPage")

function MagicBoxIllustrationPage:Init()
  self:LoadSubView()
  self:InitUI()
  self:AddListenEvent()
  self:InitFilter()
  self:UpdateEquipList()
end

function MagicBoxIllustrationPage:LoadSubView()
  local container = self:FindGO("MagicBoxIllustrationPage")
  local obj = self:LoadPreferb_ByFullPath(prefabPath, container, true)
  obj.name = "MagicBoxIllustrationPage"
end

function MagicBoxIllustrationPage:InitUI()
  self.equipFilter = self:FindGO("equipFilter"):GetComponent(UIPopupList)
  self:AddClickEvent(self:FindGO("CloseButton2"), function(go)
    GameFacade.Instance:sendNotification(MagicBoxEvent.CloseContainerview)
  end)
  local IllustrationGrid = self:FindGO("IllustrationGrid"):GetComponent(UIGrid)
  self.illustrationCtrl = UIGridListCtrl.new(IllustrationGrid, EquipIllustrationCell, "EquipIllustrationCell")
  AttrExtractionProxy.Instance:InitIllustrationEquip()
  self.emptyTip = self:FindGO("emptyTip"):GetComponent(UILabel)
  self.emptyTip.text = ZhString.MagicBox_NoEquipTip
  self.scrollView = self:FindGO("IllustrationScrollView"):GetComponent(UIScrollView)
end

function MagicBoxIllustrationPage:AddListenEvent()
  EventDelegate.Add(self.equipFilter.onChange, function()
    if self.equipFilter.data == nil then
      return
    end
    if self.filterData ~= self.equipFilter.data then
      self.filterData = self.equipFilter.data
      self:UpdateEquipList()
    end
  end)
end

function MagicBoxIllustrationPage:InitFilter()
  self.equipFilter:Clear()
  for i = 1, #FilterConfig do
    local rangeData = FilterConfig[i]
    self.equipFilter:AddItem(rangeData.name, i)
  end
  self.filterData = 1
end

function MagicBoxIllustrationPage:OnEnter()
  MagicBoxIllustrationPage.super.OnEnter(self)
end

function MagicBoxIllustrationPage:UpdateEquipList()
  local datas = AttrExtractionProxy.Instance:GetEquipDataByFilter(self.filterData) or {}
  self.emptyTip.gameObject:SetActive(#datas == 0)
  self.illustrationCtrl:ResetDatas(datas)
  self.illustrationCtrl:ResetPosition()
end
