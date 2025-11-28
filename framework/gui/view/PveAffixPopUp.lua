PveAffixPopUp = class("PveAffixPopUp", BaseView)
autoImport("PveAffixDetailCell")
PveAffixPopUp.ViewType = UIViewType.PopUpLayer

function PveAffixPopUp:Init()
  self:FindObjs()
  self:InitData()
  self:InitShow()
end

function PveAffixPopUp:FindObjs()
  self.closeBtn = self:FindGO("HideBtn")
  self:AddClickEvent(self.closeBtn, function()
    self:CloseSelf()
  end)
  self.bg = self:FindGO("Bg", self.gameObject):GetComponent(UISprite)
  local midGO = self:FindGO("Mid", self.gameObject)
  local affixContainer = self:FindComponent("AffixContainer", UIGrid, midGO)
  self.affixListCtrl = ListCtrl.new(affixContainer, PveAffixDetailCell, "PveAffixDetailCell")
  local leftBtnGO = self:FindGO("LeftBottom", self.gameObject)
  local showAllBtnGO = self:FindGO("ShowAllBtn", leftBtnGO, self.gameObject)
  self:AddClickEvent(showAllBtnGO, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WildMvpAllAffixPopup,
      viewdata = {
        AffixData = self.affixDetailData
      }
    })
  end)
  self.emptyGO = self:FindGO("EmptyLab", self.gameObject)
  self.emptyLab = self.emptyGO:GetComponent(UILabel)
  self.emptyLab.text = ZhString.WildMvpLoading
  local topGO = self:FindGO("Top", self.gameObject)
  self.titleLab = self:FindComponent("Title", UILabel, topGO)
  local title = GameConfig.StarArk and GameConfig.StarArk.AffixViewTitle or ""
  self.titleLab.text = title
end

function PveAffixPopUp:InitData()
  self.affixData = self.viewdata and self.viewdata.viewdata.AffixData or {}
  self.affixDetailData = self.viewdata and self.viewdata.viewdata.AffixDetailData or {}
end

function PveAffixPopUp:InitShow()
  local datas = self.affixData
  if datas and 0 < #datas then
    self.emptyGO:SetActive(false)
  else
    self.emptyGO:SetActive(true)
  end
  self.bg.width = datas and 3 <= #datas and 1106 or 846
  if datas then
    self.affixListCtrl:ResetDatas(datas)
  end
end
