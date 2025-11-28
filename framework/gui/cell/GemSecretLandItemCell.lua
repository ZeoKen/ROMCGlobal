local gemTipData = {}
autoImport("BaseCell")
GemSecretLandItemCell = class("GemSecretLandItemCell", BaseCell)

function GemSecretLandItemCell:Init()
  GemSecretLandItemCell.super.Init(self)
  self.bg = self:FindComponent("Background", UISprite)
  self.chooseSymbol = self:FindGO("ChooseSymbol")
  self.nameLabel = self:FindComponent("NameLabel", UILabel)
  self.gemLevel = self:FindGO("GemLevel")
  self.gemLevelLabel = self:FindComponent("GemLevelLabel", UILabel)
  self.icon = self:FindComponent("Icon_Sprite", UISprite)
  self.favoriteTip = self:FindGO("FavoriteTip")
  self.embeddedTip = self:FindGO("EmbeddedTip")
  self:AddCellClickEvent()
  self:AddCellLongPressEvent()
end

function GemSecretLandItemCell:SetData(data)
  self.data = data
  if not data then
    self:Hide()
    return
  end
  self:Show()
  self:UpdateIcon()
  self:UpdateBg()
  self:UpdateChoose()
  self:UpdateNameLabel()
  self:UpdateGemLevel()
  self:UpdateEmbeddedTip()
end

function GemSecretLandItemCell:UpdateEmbeddedTip()
  if not self.embeddedTip or not self.data then
    return
  end
  self.embeddedTip:SetActive(GemProxy.Instance:CheckSecretLandIsEmbedded(self.data:GetPos()))
end

function GemSecretLandItemCell:UpdateBg()
end

function GemSecretLandItemCell.ShowGemTip(cellGO, data, stick, side, offset, callback, isShowFuncBtns)
  if not data then
    TipManager.CloseTip()
    return
  end
  TableUtility.TableClear(gemTipData)
  gemTipData.itemdata = data
  gemTipData.callback = callback
  gemTipData.isShowFuncBtns = isShowFuncBtns or false
  return TipManager.Instance:ShowGemItemTip(gemTipData, stick, side or NGUIUtil.AnchorSide.Right, offset)
end

function GemSecretLandItemCell:UpdateIcon()
  IconManager:SetItemIcon(self.data:GetIcon(), self.icon)
  self.icon:MakePixelPerfect()
  if self.data.unlock then
    ColorUtil.WhiteUIWidget(self.icon)
  else
    ColorUtil.ShaderGrayUIWidget(self.icon)
  end
end

function GemSecretLandItemCell:SetChoose(curChooseId)
  self.curChooseId = curChooseId or 0
  self:UpdateChoose()
end

function GemSecretLandItemCell:UpdateNameLabel()
  if not self.nameLabel then
    return
  end
  if self:CheckDataIsNilOrEmpty() then
    self.nameLabel.text = ""
    return
  end
  self.nameLabel.text = self.data:GetName()
end

function GemSecretLandItemCell:UpdateChoose()
  if not self.chooseSymbol then
    return
  end
  self.chooseSymbol:SetActive(self.curChooseId ~= nil and self.curChooseId ~= 0 and not self:CheckDataIsNilOrEmpty() and self.data.id == self.curChooseId)
end

function GemSecretLandItemCell:UpdateGemLevel()
  if not self.gemLevel then
    return
  end
  local data = self.data
  local isActive = self.data.unlock == true
  self.gemLevel:SetActive(isActive)
  if isActive then
    self.gemLevelLabel.text = tostring(data.lv)
  end
end

function GemSecretLandItemCell:CheckDataIsNilOrEmpty()
  return not BagItemCell.CheckData(self.data)
end

function GemSecretLandItemCell:AddCellClickEvent()
  self:SetEvent(self.gameObject, function()
    if self.isClickDisabled then
      return
    end
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function GemSecretLandItemCell:AddCellLongPressEvent()
  local longPress = self.gameObject:GetComponent(UILongPress)
  if not longPress then
    return
  end
  
  function longPress.pressEvent(obj, state)
    self:PassEvent(MouseEvent.LongPress, {state, self})
  end
end
