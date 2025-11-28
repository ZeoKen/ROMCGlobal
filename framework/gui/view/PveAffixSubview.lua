autoImport("PveAffixDetailCell")
PveAffixSubview = class("PveAffixSubview", SubView)

function PveAffixSubview:Init(root)
  self.affixRoot = root
  self:LoadPreferb("view/PveAffixSubview", self.affixRoot, true)
  self:FindObjs()
  self:UpdateView()
end

function PveAffixSubview:UpdateAffixData(affixData, detailAffixData)
  self.affixData = affixData
  self.detailAffixData = detailAffixData
  self:UpdateView()
end

function PveAffixSubview:FindObjs()
  self.bg = self:FindGO("Bg", self.affixRoot):GetComponent(UISprite)
  local midGO = self:FindGO("Mid", self.affixRoot)
  local affixContainer = self:FindComponent("AffixContainer", UIGrid, midGO)
  self.affixListCtrl = ListCtrl.new(affixContainer, PveAffixDetailCell, "PveAffixDetailCell")
  local leftBtnGO = self:FindGO("LeftBottom", self.affixRoot)
  local showAllBtnGO = self:FindGO("ShowAllBtn", leftBtnGO, self.affixRoot)
  self:AddClickEvent(showAllBtnGO, function()
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.WildMvpAllAffixPopup,
      viewdata = {
        AffixData = self.detailAffixData
      }
    })
  end)
  self.hideBtn = self:FindGO("HideBtn", self.affixRoot)
  self:AddClickEvent(self.hideBtn, function()
    self:OnHide()
  end)
  self.emptyGO = self:FindGO("EmptyLab", self.affixRoot)
  self.emptyLab = self.emptyGO:GetComponent(UILabel)
  self.emptyLab.text = ZhString.WildMvpLoading
  local topGO = self:FindGO("Top", self.affixRoot)
  self.titleLab = self:FindComponent("Title", UILabel, topGO)
  local title = GameConfig.StarArk and GameConfig.StarArk.AffixViewTitle or ""
  self.titleLab.text = title
end

function PveAffixSubview:OnShow()
  self:Show(self.affixRoot)
  self:UpdateView()
end

function PveAffixSubview:OnHide()
  self:Hide(self.affixRoot)
end

function PveAffixSubview:UpdateView()
  if not self.affixRoot.activeInHierarchy then
    return
  end
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

function PveAffixSubview:OnDestroy()
  if self.affixListCtrl then
    self.affixListCtrl:Destroy()
  end
end
