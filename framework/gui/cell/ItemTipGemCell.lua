local _texName = "Rune_normal-matrix_fuse2"
autoImport("ItemTipBaseCell")
ItemTipGemCell = class("ItemTipGemCell", ItemTipBaseCell)

function ItemTipGemCell:Init()
  ItemTipGemCell.super.Init(self)
  self:FindObjs()
  self:AddFuncs()
  if self.favoriteButton then
    self:AddClickEvent(self.favoriteButton, function()
      self:OnFavoriteClick()
    end)
  end
end

function ItemTipGemCell:SetCustomLabWidth()
  TipLabelCell.SetDefaultLabWidth(290)
end

function ItemTipGemCell:ResetLabWidth()
  TipLabelCell.SetDefaultLabWidth(nil)
end

function ItemTipGemCell:OnDestroy()
  self:ResetLabWidth()
  if self.blurTexture then
    PictureManager.Instance:UnLoadUI(_texName, self.blurTexture)
  end
  ItemTipGemCell.super.OnDestroy(self)
end

function ItemTipGemCell:OnDisable()
  self:ResetLabWidth()
  ItemTipGemCell.super.OnDisable(self)
end

function ItemTipGemCell:FindObjs()
  self.bgSp = self:FindComponent("TipBg", UISprite)
  self.scrollviewBg = self:FindComponent("ScrollviewBg", UISprite)
  self.blurTexture = self:FindComponent("BlurTexture", UITexture)
  if self.blurTexture then
    PictureManager.Instance:SetUI(_texName, self.blurTexture)
  end
  self.funcBtnParent = self:FindGO("FuncBtns")
  self.style1FuncBtns = self:FindGO("Style1")
  self.style2FuncBtns = self:FindGO("Style2")
  self.style1FuncBtn1 = self:FindGO("FuncBtn1", self.style1FuncBtns)
  self.style2FuncBtn1 = self:FindGO("FuncBtn1", self.style2FuncBtns)
  self.style2FuncBtn2 = self:FindGO("FuncBtn2", self.style2FuncBtns)
  self.favoriteButton = self:FindGO("Favorite")
  if self.favoriteButton then
    self.favoriteSp = self.favoriteButton:GetComponent(UISprite)
  end
end

function ItemTipGemCell:InitItemCell(container)
  self:TryInitItemCell(container, "GemCell")
  if self.itemcell then
    self.itemcell:SetShowEmbeddedTip(false)
    self.itemcell:SetShowNewTag(false)
    self.itemcell:SetShowFavoriteTip(false)
  end
end

function ItemTipGemCell:AddFuncs()
  if not self.funcBtnParent then
    return
  end
  local embedFunc = function()
    FunctionItemFunc.EmbedGem()
    self:PassEvent(ItemTipEvent.ClickTipFuncEvent)
  end
  local upgradeFunc = function()
    self:UpgradeFunc()
    self:PassEvent(ItemTipEvent.ClickTipFuncEvent)
  end
  self:AddClickEvent(self.style1FuncBtn1, embedFunc)
  self:AddClickEvent(self.style2FuncBtn1, embedFunc)
  self:AddClickEvent(self.style2FuncBtn2, upgradeFunc)
end

function ItemTipGemCell:SetData(data, customWidth)
  if customWidth then
    self:SetCustomLabWidth()
  end
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if not data then
    return
  end
  ItemTipGemCell.super.SetData(self, data)
  self.scrollview:ResetPosition()
  self.scrollview.gameObject:SetActive(false)
  self.scrollview.gameObject:SetActive(true)
  self:UpdateEquipTip()
  self:UpdateFuncBtns()
  self:UpdateFavorite()
end

function ItemTipGemCell:UpdateAttriContext()
  ItemTipGemCell.super.UpdateAttriContext(self)
  local isInfoUpdated = false
  if self.data then
    isInfoUpdated = isInfoUpdated or self:UpdateAttributeGemInfo(self.data)
    isInfoUpdated = isInfoUpdated or self:UpdateSkillGemInfo(self.data)
    isInfoUpdated = isInfoUpdated or self:UpdateSkillGemStaticInfo(self.data)
    isInfoUpdated = isInfoUpdated or self:UpdateSecretLandGemInfo(self.data)
  end
  if isInfoUpdated then
    self:ResetAttriDatas()
  end
  self:ResetScrollViewBgHeight()
end

function ItemTipGemCell:ResetScrollViewBgHeight()
  if not self.scrollviewBg then
    return
  end
  if GemProxy.CheckIsSecretLandData(self.data.secretLandDatas) or GemProxy.CheckIsGemAttrData(self.data.gemAttrData) then
    self.scrollviewBg.height = 264
  else
    self.scrollviewBg.height = 310
  end
end

function ItemTipGemCell:SetShowFuncBtns(isShowFuncBtns)
  self.isShowFuncBtns = isShowFuncBtns
  self:UpdateFuncBtns()
end

function ItemTipGemCell:UpdateEquipTip()
  if not self.equipTip then
    return
  end
  self.equipTip:SetActive(GemProxy.CheckIsEmbedded(self.data))
end

function ItemTipGemCell:UpdateFuncBtns()
  if not self.funcBtnParent then
    return
  end
  if self.bgSp then
    self.bgSp.height = self.isShowFuncBtns and 634 or 560
  end
  self.funcBtnParent:SetActive(self.isShowFuncBtns or false)
  if not self.isShowFuncBtns then
    return
  end
  if GemProxy.CheckContainsGemAttrData(self.data) then
    self.style1FuncBtns:SetActive(false)
    self.style2FuncBtns:SetActive(true)
  elseif GemProxy.CheckContainsGemSkillData(self.data) then
    self.style1FuncBtns:SetActive(true)
    self.style2FuncBtns:SetActive(false)
  else
    self.isShowFuncBtns = false
    self:UpdateFuncBtns()
  end
end

function ItemTipGemCell:UpgradeFunc()
  if not GemProxy.CheckGemIsUnlocked(true) then
    return
  end
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.GemContainerView,
    viewdata = {
      page = "GemUpgradePage",
      data = self.data
    }
  })
end

function ItemTipGemCell:OnFavoriteClick()
  if not self.data then
    LogUtility.Error("Cannot find item data while marking item as favorite.")
    return
  end
  local msgId = GemProxy.CheckIsFavorite(self.data) and 32001 or 32000
  if not LocalSaveProxy.Instance:GetDontShowAgain(msgId) then
    self:PassEvent(ItemTipEvent.ConfirmMsgShowing, true)
    MsgManager.DontAgainConfirmMsgByID(msgId, function()
      self:NegateFavorite()
      self:PassEvent(ItemTipEvent.ConfirmMsgShowing, false)
    end, function()
      self:PassEvent(ItemTipEvent.ConfirmMsgShowing, false)
    end)
  else
    self:NegateFavorite()
  end
end

function ItemTipGemCell:UpdateFavorite()
  if not self.favoriteButton or not self.favoriteSp then
    return
  end
  if self.equipTip and self.equipTip.activeInHierarchy then
    self.favoriteButton:SetActive(false)
    return
  end
  local exists = BagProxy.Instance:GetItemByGuid(self.data.id, GemProxy.PackageCheck)
  self.favoriteButton:SetActive(exists ~= nil and (GemProxy.CheckContainsGemSkillData(self.data) or GemProxy.CheckContainsGemAttrData(self.data)))
  self.favoriteSp.color = GemProxy.CheckIsFavorite(self.data) and ItemTipSpriteActivatedColor or ItemTipSpriteNormalColor
end

function ItemTipGemCell:NegateFavorite()
  if not self.data then
    LogUtility.Error("Cannot negate favorite of item while item data == nil!")
    return
  end
  local packType
  if GemProxy.CheckContainsGemAttrData(self.data) then
    packType = SceneItem_pb.EPACKTYPE_GEM_ATTR
  elseif GemProxy.CheckContainsGemSkillData(self.data) then
    packType = SceneItem_pb.EPACKTYPE_GEM_SKILL
  elseif GemProxy.CheckContainsGemSecretLandData(self.data) then
    packType = SceneItem_pb.EPACKTYPE_GEM_SECRETLAND
  end
  BagProxy.Instance:TryNegateFavoriteOfItem(self.data, packType)
end
