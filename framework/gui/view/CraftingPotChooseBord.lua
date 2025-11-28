autoImport("CraftingItemChooseCell")
CraftingPotChooseBord = class("CraftingPotChooseBord", CoreView)
CraftingPotChooseBord.PfbPath = "part/CraftingPotChooseBord"
CraftingPotChooseBord.ChooseItem = "CraftingPotChooseBord_ChooseItem"
local itemTipOffset = {216, -290}

function CraftingPotChooseBord:ctor(parent, getDataFunc)
  self.gameObject_Parent = parent
  self.gameObject = self:LoadPreferb(self.PfbPath, parent)
  self.gameObject.transform.localPosition = LuaGeometry.Const_V3_zero
  self:InitBord()
end

function CraftingPotChooseBord:InitBord()
  self:InitDepth()
  self.title = self:FindComponent("Title", UILabel)
  self.title.text = ZhString.CraftingPot_ChooseBordTitle
  local grid = self:FindComponent("Grid", UIGrid)
  self.itemList = UIGridListCtrl.new(grid, CraftingItemChooseCell, "CraftingItemChooseCell")
  self.itemList:AddEventListener(MouseEvent.MouseClick, self.OnClickProduct, self)
end

function CraftingPotChooseBord:InitDepth()
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject_Parent, UIPanel, false)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
end

function CraftingPotChooseBord:HandleClickItem(cellctl)
  local data = cellctl and cellctl.data
  self:SetChoose(data)
  self:PassEvent(CraftingPotChooseBord.ChooseItem, data)
  if self.chooseCall then
    self.chooseCall(self.chooseCallParam, data)
  end
end

function CraftingPotChooseBord:SetChoose(data)
  local datas = CraftingPotProxy.Instance:GetPurifyProducts()
  self.itemList:ResetDatas(datas)
end

function CraftingPotChooseBord:OnClickProduct(cellctl)
  local data = cellctl and cellctl.data
  CraftingPotProxy.Instance:SetChoosePurifyProducts(data.productItemID)
  self:PassEvent(CraftingPotChooseBord.ChooseItem, data)
  self:UpdateChooseInfo()
end

function CraftingPotChooseBord:UpdateChooseInfo()
  local datas = CraftingPotProxy.Instance:GetPurifyProducts()
  self.itemList:ResetDatas(datas)
end

function CraftingPotChooseBord:Show(updateInfo, chooseCall, chooseCallParam, checkFunc, checkFuncParam, checkTip)
  if updateInfo then
    self:UpdateChooseInfo()
  end
  self.gameObject:SetActive(true)
  self.chooseCall = chooseCall
  self.chooseCallParam = chooseCallParam
end

function CraftingPotChooseBord:Hide()
  TipManager.CloseTip()
  self.gameObject:SetActive(false)
  self.chooseCall = nil
  self.chooseCallParam = nil
  self.checkFunc = nil
  self.checkTip = nil
end

function CraftingPotChooseBord:ActiveSelf()
  return self.gameObject.activeSelf
end

function CraftingPotChooseBord:SetNoneTip(text)
  self.noneTip.text = text
end

function CraftingPotChooseBord:__OnViewDestroy()
  self:OnComponentDestroy()
  TableUtility.TableClear(self)
end
