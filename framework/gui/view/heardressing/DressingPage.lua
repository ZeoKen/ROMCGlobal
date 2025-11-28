DressingPage = class("DressingPage", SubView)

function DressingPage:Init()
  self:FindObjs()
  self:AddEvent()
  self:InitPageView()
end

function DressingPage:AddEvent()
  self:AddListenEvt(ServiceEvent.SessionShopQueryShopConfigCmd, self.UpdateShop)
end

function DressingPage:UpdateShop()
  self:InitPageView()
end

function DressingPage:FindObjs()
  self.desc = self:FindGO("desc"):GetComponent(UILabel)
  self.menuDes = self:FindGO("menuDes"):GetComponent(UILabel)
  self.itemRoot = self:FindGO("Wrap")
end

function DressingPage:InitPageView()
  self.itemWrapHelper = nil
  self.itemWrapHelper2 = nil
end

function DressingPage:SetDes(data)
  if data.des and data.des ~= "" then
    self:Show(self.desc)
    if not BranchMgr.IsChina() and data.des and data.clothColorID then
      local originName = Table_Couture[data.clothColorID].NameZh
      local tmp = string.gsub(data.des, originName, "%%s")
      local res = tmp and string.format(OverSea.LangManager.Instance():GetLangByKey(tmp), OverSea.LangManager.Instance():GetLangByKey(originName))
      self.desc.text = res or data.des
    else
      self.desc.text = data.des
    end
  else
    self:Hide(self.desc)
  end
end

function DressingPage:SetMenuDes(data, type)
  self:Hide(self.menuDes)
end

function DressingPage:OnEnter()
  DressingPage.super.OnEnter(self)
  self:UpdateShop()
end

function DressingPage:OnExit()
  DressingPage.super.OnExit(self)
end

function DressingPage:SetChoose(id)
  if not self.itemWrapHelper then
    return
  end
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local cell = cells[i]
    for j = 1, #cell.childrenObjs do
      local child = cell.childrenObjs[j]
      child:SetChoose(id)
    end
  end
end

function DressingPage:ResetEquiped()
  if not self.itemWrapHelper then
    return
  end
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local cell = cells[i]
    for j = 1, #cell.childrenObjs do
      local child = cell.childrenObjs[j]
      if child.SetEquiped then
        child:SetEquiped()
      end
    end
  end
end

function DressingPage:UpdateUnlock()
  if not self.itemWrapHelper then
    return
  end
  local cells = self.itemWrapHelper:GetCellCtls()
  for i = 1, #cells do
    local cell = cells[i]
    for j = 1, #cell.childrenObjs do
      local child = cell.childrenObjs[j]
      child:UpdateUnlock(id)
    end
  end
end

function DressingPage:SetDyeChoose(id)
  if self.itemWrapHelper2 then
    local cells = self.itemWrapHelper2:GetCellCtls()
    for i = 1, #cells do
      cells[i]:SetChoose(id)
    end
  end
end

function DressingPage:ResetDyeEquiped()
  if self.itemWrapHelper2 then
    local cells = self.itemWrapHelper2:GetCellCtls()
    for i = 1, #cells do
      if cells[i].SetEquiped then
        cells[i]:SetEquiped()
      end
    end
  end
end

function DressingPage:ResetChoose()
  self.chooseId = nil
  self.chooseCtl = nil
  self:SetChoose()
  self:SetDyeChoose()
end
