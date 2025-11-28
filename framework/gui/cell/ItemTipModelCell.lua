local BaseCell = autoImport("BaseCell")
ItemTipModelCell = class("ItemTipModelCell", BaseCell)
autoImport("FashionPreviewTip")
autoImport("Table_ItemBeTransformedWay")
autoImport("CardNCell")
autoImport("ItemTipBaseCell")
autoImport("AdventureGroupItemCell")
autoImport("ItemTipModelSkillCell")
autoImport("AdventureTipLabelCell")
ItemTipModelCell.CardNCellResPath = ResourcePathHelper.UICell("CardNCell")
local tempV3 = LuaVector3()
local tempTable = {}
local texName_NoPreviewBG = "com_bg_scene"
local texName_NoPreviewCat = "adventure_kong"
local labEffectColor = Color(0.6862745098039216, 0.3764705882352941, 0.10588235294117647)
local GreyOutline = Color(0.5019607843137255, 0.5019607843137255, 0.5019607843137255, 1)
local OrangeOutline = Color(0.6862745098039216, 0.3764705882352941, 0.10588235294117647, 1)
ItemTipModelCell.ModelPos = {
  [1] = {
    position = LuaVector3(-0.31, 0.53, 3.89),
    rotation = LuaQuaternion.Euler(0, -34, 0)
  },
  [2] = {
    position = LuaVector3(-1.91, 0.45, 3.31),
    rotation = LuaQuaternion.Euler(0, 0, 0)
  }
}

function ItemTipModelCell:Init()
  local l_tsfModelHolder = self.trans:Find("MainPanel/Top/PlayerModelContainer")
  self.modelHodler = l_tsfModelHolder.gameObject
  self.adventureValue = l_tsfModelHolder:Find("scoreCt/adventureValue"):GetComponent(UILabel)
  local l_tsfCardHolder = self.trans:Find("MainPanel/Top/CardCellHolder")
  self.cardHodler = l_tsfCardHolder.gameObject
  local l_tsfAdventureValueCt = l_tsfCardHolder:Find("adventureValueCt")
  self.adventureValueCt = l_tsfAdventureValueCt.gameObject
  self.adventureValueCt:SetActive(false)
  self.adventureValueCard = l_tsfAdventureValueCt:Find("adventureValueCard"):GetComponent(UILabel)
  self.objitemmodeltexture = l_tsfModelHolder:Find("ModelTexture").gameObject
  self.itemmodeltexture = self.objitemmodeltexture:GetComponent(UITexture)
  self.ItemName = l_tsfModelHolder:Find("modelBottombg/ItemName"):GetComponent(UILabel)
  self.tsfBottomCt = self.trans:Find("BeforePanel/LockBordHolder/LockBord/BottomCt")
  self.lockTipLabel = self.tsfBottomCt:Find("LockTipLabel"):GetComponent(UILabel)
  local l_tsfCenter = self.trans:Find("MainPanel/Center")
  self.center = l_tsfCenter.gameObject
  local l_tsfScrollView = l_tsfCenter:Find("ScrollView")
  self.scrollView = l_tsfScrollView:GetComponent(UIScrollView)
  local l_tsfCenterTable = l_tsfScrollView:Find("CenterTable")
  self.centerTable = l_tsfCenterTable:GetComponent(UITable)
  local l_tsfUnlockReward = l_tsfCenterTable:Find("UnlockReward")
  self.objUnlockReward = l_tsfUnlockReward.gameObject
  self.objUnlockReward:SetActive(false)
  self.fixedAttrLabel = l_tsfUnlockReward:Find("FixAttrCt/fixedAttrLabel"):GetComponent("UILabel")
  self.LockReward = l_tsfUnlockReward:Find("LockReward"):GetComponent(UILabel)
  self.LockReward.text = ZhString.MonsterTip_LockReward
  local modelBg = l_tsfModelHolder:Find("ModelBg").gameObject
  self:AddDragEvent(modelBg, function(go, delta)
    if self.model_Fashion2 then
      self.model_Fashion2:RotateDelta(-delta.x)
    end
    if self.model_Fashion3 then
      self.model_Fashion3:RotateDelta(-delta.x)
    end
    if not self.model then
      return
    end
    if type(self.model) == "table" and self.model.RotateDelta then
      self.model:RotateDelta(-delta.x)
      return
    end
    LuaGameObject.LocalRotateDeltaByAxisY(self.model.transform, -delta.x)
  end)
  self:InitSkillContext()
  self:InitAttriContext()
  self:initDropRelate()
  self.BottomGrid = self.trans:Find("MainPanel/Bottom"):GetComponent(UIGrid)
  self.userdata = Game.Myself.data.userdata
  self.objGroupItems = l_tsfCenterTable:Find("GroupItems").gameObject
  self.labGroupItemName = self:FindComponent("labGroupItemName", UILabel, self.objGroupItems)
  self.scrollGroupItems = self:FindComponent("listGroupItem", UIScrollView, self.objGroupItems)
  self.listGroupItems = UIGridListCtrl.new(self:FindComponent("gridGroupItem", UIGrid, self.objGroupItems), AdventureGroupItemCell, "AdventureGroupItemCell")
  self.listGroupItems:AddEventListener(MouseEvent.MouseClick, self.SelectGroupItemCell, self)
  self.objNoPreview = l_tsfModelHolder:Find("NoPreview").gameObject
  self.texNoPreviewBG = self:FindComponent("NoPreviewBG", UITexture, self.objNoPreview)
  self.texNoPreviewCat = self:FindComponent("NoPreviewCat", UITexture, self.objNoPreview)
  PictureManager.Instance:SetUI(texName_NoPreviewBG, self.texNoPreviewBG)
  PictureManager.Instance:SetUI(texName_NoPreviewCat, self.texNoPreviewCat)
end

function ItemTipModelCell:CloseGainWayTip()
  if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  end
end

function ItemTipModelCell:initDropRelate()
  self.dropContainer = self.trans:Find("BeforePanel/DropContainer").gameObject
  local l_tsfLockBord = self.trans:Find("BeforePanel/LockBordHolder/LockBord")
  self.getPathBtn = l_tsfLockBord:Find("getPathBtn").gameObject
  self.MakeHeadDress = self.trans:Find("MainPanel/Bottom/MakeHeadDress").gameObject
  self.UseToy = self.trans:Find("MainPanel/Bottom/UseToy").gameObject
  self.labUseToy = self:FindComponent("Label", UILabel, self.UseToy)
  self.labUseToy.text = ZhString.AdventurePanel_ToyUse
  self.labMakeHeadDress = self:FindComponent("Label", UILabel, self.MakeHeadDress)
  self.RedTip = self:FindGO("RedTip", self.MakeHeadDress)
  self.getPathBtn:SetActive(true)
  local btnText = self:FindComponent("Label", UILabel, self.getPathBtn)
  btnText.text = ZhString.ItemScoreTip_GetPathDes
  self.getWayBtn = self.trans:Find("MainPanel/Bottom/GetWayBtn").gameObject
  if self.getWayBtn then
    self:AddClickEvent(self.getWayBtn, function(go)
      local sId = (not self.curSelectGroupItemCell or not self.curSelectGroupItemCell.staticId) and self.data and self.data.staticId
      if sId then
        if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
          self.gainwayCtl:OnExit()
          self.gainwayCtl = nil
        else
          self.gainwayCtl = GainWayTip.new(self.dropContainer)
          self.gainwayCtl:SetData(sId)
        end
      end
    end)
  end
  self:AddClickEvent(self.getPathBtn, function(go)
    local sId = (not self.curSelectGroupItemCell or not self.curSelectGroupItemCell.staticId) and self.data and self.data.staticId
    if sId then
      if self.gainwayCtl and not self:ObjIsNil(self.gainwayCtl.gameObject) then
        self.gainwayCtl:OnExit()
        self.gainwayCtl = nil
      else
        self.gainwayCtl = GainWayTip.new(self.dropContainer)
        self.gainwayCtl:SetData(sId)
      end
    end
  end)
  self:AddClickEvent(self.MakeHeadDress, function(go)
    if self.data and self.data.staticData then
      if self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.HomeTipPopUp,
          viewdata = self.data.staticId
        })
        return
      end
      GameFacade.Instance:sendNotification(UIEvent.ShowUI, {
        viewname = "PicTipPopUp",
        data = self.data
      })
    end
  end)
  self:AddClickEvent(self.UseToy, function(go)
    if self.data.store and self.data and self.data.staticData and self.data.savedItemDatas and next(self.data.savedItemDatas) and self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
      local cdTime = self.data:GetCdTimeOfAnySavedItem()
      if 0 < cdTime then
        MsgManager.ShowMsgByID(933)
      else
        FunctionItemFunc.TryUseItem(self.data.savedItemDatas[1])
        GameFacade.Instance:sendNotification(AdventurePanel.ClosePanel)
      end
    end
  end)
  self.wearBtn = l_tsfLockBord:Find("wearBtn").gameObject
  self:AddClickEvent(self.wearBtn, function()
    if (self.data:IsWeapon() or self.data:IsShield()) and not self.data.equipInfo:CanUseByProfess(MyselfProxy.Instance:GetMyProfession()) then
      MsgManager.ShowMsgByIDTable(27201)
      return
    end
    if self.data.equipInfo and self.data.equipInfo:IsMyDisplayForbid() then
      MsgManager.ShowMsgByID(40310)
      return
    end
    self:ShowFashionPreview()
  end)
  self.PackageBtn = self.trans:Find("MainPanel/Bottom/PackageBtn").gameObject
  self.PackageBtnComp = self.PackageBtn:GetComponent(UIButton)
  self.PackageLabel = self:FindComponent("Label", UILabel, self.PackageBtn)
  self:AddClickEvent(self.PackageBtn, function(go)
    if not self.data or not self.data.staticData then
      return
    end
    if self.data:IsLimitPackageByLv() then
      MsgManager.ShowMsgByIDTable(39001)
      return
    end
    if self.curSelectGroupItemCell then
      if self.curSelectGroupItemCell.store then
        ServiceSceneManualProxy.Instance:CallGetManualCmd(self.data.type, self.curSelectGroupItemCell.staticId)
      else
        local itemData = BagProxy.Instance:GetItemByStaticID(self.curSelectGroupItemCell.staticId)
        if not itemData then
          MsgManager.ShowMsgByIDTable(570, {
            self.curSelectGroupItemCell.staticId
          })
        else
          itemData = BagProxy.Instance:GetItemByStaticIDWithoutCard(self.curSelectGroupItemCell.staticId)
          if not itemData then
            MsgManager.ShowMsgByIDTable(549)
          else
            ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemData.id)
          end
        end
      end
      return
    end
    if self.data.store then
      local staticId = #self.data.savedItemDatas > 0 and self.data.savedItemDatas[1].staticData.id or self.data.staticId
      ServiceSceneManualProxy.Instance:CallGetManualCmd(self.data.type, staticId)
    else
      local card = self.data.type == SceneManual_pb.EMANUALTYPE_CARD
      if card then
        if not BagProxy.Instance:GetItemByStaticID(self.data.staticId) then
          MsgManager.ShowMsgByIDTable(570, {
            self.data.staticId
          })
        else
          local itemData = BagProxy.Instance:GetItemByStaticIDWithoutCard(self.data.staticId)
          if not itemData then
            MsgManager.ShowMsgByIDTable(549)
          else
            ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemData.id)
          end
        end
      else
        if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
          local itemData = BagProxy.Instance:GetItemByStaticID(self.data.staticId)
          if not itemData then
            MsgManager.ShowMsgByIDTable(570, {
              self.data.staticId
            })
          else
            ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemData.id)
          end
          return
        end
        if self.data.type == SceneManual_pb.EMANUALTYPE_MOUNT and self.data:IsPetMount() then
          local itemDatas = BagProxy.Instance:GetItemsByStaticID(self.data.staticId, BagProxy.BagType.Pet)
          if not itemDatas or #itemDatas == 0 then
            MsgManager.ShowMsgByIDTable(570, {
              self.data.staticId
            })
          else
            for i = 1, #itemDatas do
              if itemDatas[i]:CanEquip(true) then
                ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemDatas[i].id)
                return
              end
            end
            MsgManager.ShowMsgByIDTable(27205)
          end
          return
        end
        local datas = AdventureDataProxy.Instance:GetFashionEquipByStaticNormal(self.data)
        if not self.data:IsWeapon() and not self.data:IsShield() and not self.data.equipInfo.equipData.GroupID and not BagProxy.Instance:GetItemByStaticID(self.data.staticId) then
          MsgManager.ShowMsgByIDTable(570, {
            self.data.staticId
          })
        elseif not datas or #datas == 0 then
          MsgManager.ShowMsgByIDTable(570, {
            self.data.staticId
          })
        else
          local itemDatas = AdventureDataProxy.Instance:GetFashionEquipByStatic(self.data)
          if not itemDatas or #itemDatas == 0 then
            MsgManager.ShowMsgByIDTable(549)
          else
            ServiceSceneManualProxy.Instance:CallStoreManualCmd(self.data.type, itemDatas[1].id)
          end
        end
      end
    end
  end)
  self.UseEffectSkill = self.trans:Find("MainPanel/Bottom/UseEffectSkill").gameObject
  self.labUseEffectSkill = self:FindComponent("Label", UILabel, self.UseEffectSkill)
  self.labUseEffectSkill.text = ZhString.AdventurePanel_UseEffectSkill
  self:AddClickEvent(self.UseEffectSkill, function(go)
    local cells = self.skillCtl:GetCells()
    if cells and next(cells) then
      if cells[1].skillcdCell:GetCD() > 0 then
        MsgManager.FloatMsg("", ZhString.AdventurePanel_UseEffectSkill_InCD)
        return
      end
      local skillid = cells[1].id
      FunctionSkill.Me():TryUseSkill(skillid)
      GameFacade.Instance:sendNotification(AdventurePanel.ClosePanel)
    end
  end)
end

function ItemTipModelCell:SetUnlockCondition()
  local str = AdventureDataProxy.getUnlockCondition(self.data)
  local size = 270
  if not self.data.cardInfo then
    size = 380
    self.lockTipLabel.text = self.data.staticData.NameZh
    self.lockTipLabel.fontSize = 30
  else
    self.lockTipLabel.text = str
    self.lockTipLabel.fontSize = 22
  end
  if size <= self.lockTipLabel.width then
    self.lockTipLabel.overflowMethod = 1
    self.lockTipLabel.width = size
    UIUtil.WrapLabel(self.lockTipLabel)
  else
    self.lockTipLabel.overflowMethod = 2
  end
end

function ItemTipModelCell:SetUnlockReward()
  local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
  local rewardStr = AdventureDataProxy.Instance:getUnlockRewardStr(self.data.staticData)
  local fixedAttrLabelText = unlockCondition
  if unlockCondition and unlockCondition ~= "" then
    if rewardStr and rewardStr ~= "" then
      fixedAttrLabelText = string.format("%s,%s", unlockCondition, rewardStr)
    end
    self.fixedAttrLabel.text = fixedAttrLabelText
  end
end

function ItemTipModelCell:updateWidgetColor()
  if not self.isUnlock then
    local childs = Game.GameObjectUtil:GetAllComponentsInChildren(self.objUnlockReward, UILabel, true)
    for i = 1, #childs do
      local obj = childs[i]
      ColorUtil.GrayUIWidget(obj)
    end
    childs = Game.GameObjectUtil:GetAllComponentsInChildren(self.objUnlockReward, UISprite, true)
    for i = 1, #childs do
      local obj = childs[i]
      ColorUtil.ShaderGrayUIWidget(obj)
    end
  else
    local childs = Game.GameObjectUtil:GetAllComponentsInChildren(self.objUnlockReward, UILabel, true)
    for i = 1, #childs do
      local obj = childs[i]
      ColorUtil.BlackLabel(obj)
    end
    self.LockReward.color = LuaGeometry.GetTempColor(1, 0.3843137254901961, 0.17254901960784313, 1)
  end
end

function ItemTipModelCell:CanStoreSelectedItem()
  if self.curSelectGroupItemCell then
    local itemData = BagProxy.Instance:GetItemByStaticID(self.curSelectGroupItemCell.staticId)
    return itemData and true or false
  end
  if not self.data then
    return false
  end
  if self.data.type == SceneManual_pb.EMANUALTYPE_CARD or self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
    local itemData = BagProxy.Instance:GetItemByStaticID(self.data.staticId)
    return itemData and true or false
  end
  if self.data.type == SceneManual_pb.EMANUALTYPE_MOUNT and self.data:IsPetMount() then
    local itemDatas = BagProxy.Instance:GetItemsByStaticID(self.data.staticId, BagProxy.BagType.Pet)
    if not itemDatas or #itemDatas == 0 then
      return false
    end
    for i = 1, #itemDatas do
      if itemDatas[i]:CanEquip(true) then
        return true
      end
    end
    return false
  end
  local datas = AdventureDataProxy.Instance:GetFashionEquipByStaticNormal(self.data)
  if not self.data:IsWeapon() and not self.data:IsShield() and (not self.data.equipInfo or not self.data.equipInfo.equipData.GroupID) and not BagProxy.Instance:GetItemByStaticID(self.data.staticId) then
    return false
  elseif not datas or #datas == 0 then
    return false
  else
    local itemDatas = AdventureDataProxy.Instance:GetFashionEquipByStatic(self.data)
    if not itemDatas or #itemDatas == 0 then
      return false
    else
      return true
    end
  end
end

function ItemTipModelCell:UpdatePackageBtn(forceEnable)
  if forceEnable or self:CanStoreSelectedItem() then
    self.PackageBtnComp.isEnabled = true
    self.PackageLabel.effectColor = OrangeOutline
    return
  end
  self.PackageBtnComp.isEnabled = false
  self.PackageLabel.effectColor = GreyOutline
end

function ItemTipModelCell:UpdateGetWayBtn()
  local forceState = false
  if self.data then
    if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
      forceState = false
    elseif (self.data.cardInfo or BagProxy.fashionType[self.data.staticData.Type] or self.data.tabData.id == 1045) and self.MakeHeadDress.activeInHierarchy then
      forceState = false
    end
  else
    forceState = false
  end
  if forceState == nil then
    local sId = (not self.curSelectGroupItemCell or not self.curSelectGroupItemCell.staticId) and self.data and self.data.staticId
    forceState = false
    if sId then
      local getWayData = GainWayTipProxy.Instance:GetDataByStaticID(sId)
      if GainWayTipProxy.V1 then
        if getWayData and 0 < #getWayData then
          forceState = true
        end
      elseif getWayData and 0 < #getWayData.datas then
        forceState = true
      end
    end
  end
  if self.UseEffectSkill.activeInHierarchy then
    forceState = false
  end
  if not self:ObjIsNil(self.getWayBtn) then
    self.getWayBtn:SetActive(false)
  end
  if not self:ObjIsNil(self.getPathBtn) then
    local show = self.getPathBtn.activeSelf or forceState
    self.getPathBtn:SetActive(show)
  end
end

function ItemTipModelCell:UpdateCardTabBtns()
  self.wearBtn:SetActive(false)
  self.UseToy:SetActive(false)
  self.UseEffectSkill:SetActive(false)
  local showMakeBtn = false
  self.MakeHeadDress:SetActive(showMakeBtn)
  self.PackageBtn:SetActive(not showMakeBtn)
end

function ItemTipModelCell:adjustCardViewLockView()
  self:UpdateCardTabBtns()
  self.BottomGrid:Reposition()
  local pos = self.scrollView.transform.localPosition
  if self.scrollView.panel then
    local clip = self.scrollView.panel.baseClipRegion
    self.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, 464, 114)
    self.scrollView.panel.clipOffset = LuaGeometry.GetTempVector2(0, 0)
  end
  self.scrollView.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, -36, pos.z)
  local sbg = self.tsfBottomCt:Find("Bg/SpriteBg"):GetComponent(UISprite)
  sbg.width = 270
  local pos = LuaGeometry.TempGetLocalPosition(self.tsfBottomCt)
  self.tsfBottomCt.localPosition = LuaGeometry.GetTempVector3(pos.x, -373.3, pos.y)
  self.getPathBtn.transform.localPosition = LuaGeometry.GetTempVector3(144, -17, 0)
  self.lockTipLabel.pivot = UIWidget.Pivot.Center
  local pos = self.lockTipLabel.transform.localPosition
  self.lockTipLabel.transform.localPosition = LuaGeometry.GetTempVector3(0, pos.y, pos.z)
  NGUITools.AddWidgetCollider(self.center, true)
end

function ItemTipModelCell:adjustModelViewLockView()
  local npcCfg = GameConfig.Item2Npc
  if self.data.type == SceneManual_pb.EMANUALTYPE_TOY or self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE or npcCfg and npcCfg[self.data.staticId] then
    self.wearBtn:SetActive(false)
  elseif self.data:IsShield() then
    local cfgShowShield = GameConfig.Profession.show_shield_typeBranches
    self.wearBtn:SetActive(cfgShowShield ~= nil and TableUtility.ArrayFindIndex(cfgShowShield, MyselfProxy.Instance:GetMyProfessionTypeBranch()) > 0)
  else
    self.wearBtn:SetActive(true)
  end
  local hideConfig = GameConfig.AdventureNoPackage and GameConfig.AdventureNoPackage.item
  if self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE or hideConfig and TableUtility.ArrayFindIndex(hideConfig, self.data.staticId) > 0 then
    self.PackageBtn:SetActive(false)
  else
    self.PackageBtn:SetActive(true)
  end
  local staticData = Table_ItemBeTransformedWay[self.data.staticId]
  if staticData and self.data.tabData.id ~= 1045 and self.data.type ~= SceneManual_pb.EMANUALTYPE_TOY and not self.data:IsWeapon() and not self.data:IsShield() and not self.data:IsTrolley() then
    self.MakeHeadDress:SetActive(true)
  else
    self.MakeHeadDress:SetActive(false)
  end
  if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
    if self.data.store then
      self:SetTextureWhite(self.UseToy)
      self.UseToy:GetComponent(BoxCollider).enabled = true
      self.labUseToy.effectColor = labEffectColor
    else
      self:SetTextureGrey(self.UseToy)
      self.UseToy:GetComponent(BoxCollider).enabled = false
    end
    self.UseToy:SetActive(true)
  else
    self.UseToy:SetActive(false)
  end
  self.UseEffectSkill:SetActive(false)
  self.BottomGrid:Reposition()
  local pos = self.scrollView.transform.localPosition
  if self.scrollView.panel then
    local clip = self.scrollView.panel.baseClipRegion
    self.scrollView.panel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, 463.9, 242.85)
    self.scrollView.panel.clipOffset = LuaGeometry.GetTempVector2(0, 0)
  end
  self.scrollView.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, 33, pos.z)
  self:Hide(self.adventureValueCard.gameObject.transform.parent)
  local sbg = self:FindComponent("SpriteBg", UISprite)
  sbg.width = 448
  self.lockTipLabel.pivot = UIWidget.Pivot.Left
  local pos = self.lockTipLabel.transform.localPosition
  self.lockTipLabel.transform.localPosition = LuaGeometry.GetTempVector3(-sbg.width / 2 + 10, pos.y, pos.z)
  local pos = LuaGeometry.TempGetLocalPosition(self.tsfBottomCt)
  self.tsfBottomCt.localPosition = LuaGeometry.GetTempVector3(pos.x, -241.4, pos.y)
  self.getPathBtn.transform.localPosition = LuaGeometry.GetTempVector3(156, -37, 0)
  NGUITools.AddWidgetCollider(self.center, true)
  local islock = not self.data.store and self.data.status == SceneManual_pb.EMANUALSTATUS_DISPLAY
  self.RedTip:SetActive(false)
end

function ItemTipModelCell:initData()
  self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
  if self.data.cardInfo then
    self.cardHodler:SetActive(true)
    self.modelHodler:SetActive(false)
    self:initCardCell()
    self:adjustCardViewLockView()
  elseif self.data.tabData.id == 1045 then
    self.cardHodler:SetActive(false)
    self.modelHodler:SetActive(true)
    self:removeCardCell()
    self:adjustModelViewLockView()
  elseif BagProxy.fashionType[self.data.staticData.Type] or self.data.type == SceneManual_pb.EMANUALTYPE_TOY or self.data.type == SceneManual_pb.EMANUALTYPE_MOUNT or self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE or self.data:IsWeapon() or self.data:IsShield() then
    self.cardHodler:SetActive(false)
    self.modelHodler:SetActive(true)
    self:removeCardCell()
    self:adjustModelViewLockView()
  end
  if self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE then
    self.labMakeHeadDress.text = ZhString.ItemScoreTip_MakeFurniture
  else
    self.labMakeHeadDress.text = ZhString.ItemScoreTip_MakeHeadDress
  end
  self:UpdateGetPathBtn(self.data)
  local value = 0
  if self.data and self.data.staticData and self.data.staticData.AdventureValue then
    value = self.data.staticData.AdventureValue
  end
  self.adventureValueCard.text = value
  self.adventureValue.text = value
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
end

function ItemTipModelCell:initCardCell()
  if self.cardCell and self.cardCell.gameObject then
    return
  end
  local obj = self:FindGO("CardNCell")
  if not obj then
    obj = Game.AssetManager_UI:CreateAsset(ItemTipModelCell.CardNCellResPath, self.cardHodler)
    obj.transform.localPosition = LuaGeometry.Const_V3_zero
    obj.transform.localScale = LuaGeometry.Const_V3_one
    obj.name = "CardNCell"
  end
  self.cardCell = CardNCell.new(obj)
  self.cardCell:SetData(self.itemData)
  self.cardCell:Hide(self.cardCell.useButton.gameObject)
end

function ItemTipModelCell:removeCardCell()
  if self.cardCell then
    Game.GOLuaPoolManager:AddToUIPool(ItemTipModelCell.CardNCellResPath, self.cardCell.gameObject)
    self.cardCell = nil
  end
end

function ItemTipModelCell:InitSkillContext()
  self.skillTable = self.trans:Find("MainPanel/Center/ScrollView/CenterTable/SkillTable").gameObject
  self.skillTable1 = self:FindComponent("SkillTable1", UITable, self.skillTable)
  self.skillTable2 = self:FindComponent("SkillTable2", UITable, self.skillTable)
  self.skillCtl = UIGridListCtrl.new(self.skillTable2, ItemTipModelSkillCell, "ItemTipModelSkillCell")
end

function ItemTipModelCell:InitAttriContext()
  self.table = self.trans:Find("MainPanel/Center/ScrollView/CenterTable/AttriTable"):GetComponent(UITable)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
  local tip = self:FindGO("TipLabelCell", self.table.gameObject)
  self.tipLabel = TipLabelCell.new(tip)
  self.tipLabel.gameObject:SetActive(false)
  self.attriCtl = UIGridListCtrl.new(self.table, AdventureTipLabelCell, "AdventureTipLabelCell")
end

function ItemTipModelCell:SetData(data, chooseState)
  self.data = data
  if self.gainwayCtl then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  end
  if data then
    self:initData()
    self.gameObject:SetActive(true)
    if not self:UpdateGroupItems() then
      self:UpdateTopModel(chooseState)
      self:UpdateStoreState()
    end
    self:UpdateTopInfo()
    self:UpdateAttriContext()
    self:SetUnlockCondition()
    self:SetUnlockReward()
    self:UpdateGetWayBtn()
    self.BottomGrid:Reposition()
    self.centerTable:Reposition()
    self.scrollView:ResetPosition()
  else
    self.gameObject:SetActive(false)
  end
end

function ItemTipModelCell:UpdateStoreState()
  if self.data.cardInfo then
    self:UpdatePackageBtn(true)
    if self.data.store then
      self.PackageLabel.text = ZhString.AdventurePanel_CardOutAdventurePackage
    else
      self.PackageLabel.text = ZhString.AdventurePanel_CardIntoAdventurePackage
    end
  else
    local store = false
    if self.curSelectGroupItemCell then
      store = self.curSelectGroupItemCell.store
    else
      store = self.data.store
    end
    if store then
      if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
        self.PackageLabel.text = ZhString.AdventurePanel_ToyOutAdventurePackage
      elseif self.data.type == SceneManual_pb.EMANUALTYPE_MOUNT then
        self.PackageLabel.text = ZhString.AdventurePanel_MountOutAdventurePackage
      elseif self.data:IsWeapon() or self.data:IsShield() or self.data:IsTrolley() then
        self.PackageLabel.text = ZhString.AdventurePanel_EquipOutAdventurePackage
      else
        self.PackageLabel.text = ZhString.AdventurePanel_ItemOutAdventurePackage
      end
      self:UpdatePackageBtn(true)
    else
      if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
        self.PackageLabel.text = ZhString.AdventurePanel_ToyIntoAdventurePackage
      elseif self.data.type == SceneManual_pb.EMANUALTYPE_MOUNT then
        self.PackageLabel.text = ZhString.AdventurePanel_MountIntoAdventurePackage
      elseif self.data:IsWeapon() or self.data:IsShield() or self.data:IsTrolley() then
        self.PackageLabel.text = ZhString.AdventurePanel_EquipIntoAdventurePackage
      else
        self.PackageLabel.text = ZhString.AdventurePanel_ItemIntoAdventurePackage
      end
      self:UpdatePackageBtn()
    end
  end
end

function ItemTipModelCell:FormatBufferStr(bufferId)
  local str = ItemUtil.getBufferDescById(bufferId)
  return str
end

function ItemTipModelCell:GetItemDetail()
  local temp = {}
  temp.label = {}
  temp.labelType = AdventureDataProxy.LabelType.Status
  local advReward = self.data.staticData.AdventureReward
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local singleLabel = {
      text = AdventureDataProxy.getUnlockCondition(self.data) .. ZhString.FunctionDialogEvent_And .. "{uiicon=Adventure_icon_05}x" .. self.data.staticData.AdventureValue
    }
    local rewardTeams = advReward and advReward.rewardid
    if rewardTeams then
      local tbItem = Table_Item
      local rewardItemsInfo, itemSData
      for _, teamId in pairs(rewardTeams) do
        rewardItemsInfo = ItemUtil.GetRewardItemIdsByTeamId(teamId)
        if rewardItemsInfo then
          for _, singleRewardInfo in pairs(rewardItemsInfo) do
            if singleRewardInfo.type == 1 then
              itemSData = tbItem[singleRewardInfo.id]
              if itemSData then
                singleLabel.text = string.format("%s%s%sx%s", singleLabel.text, ZhString.ItemTip_ChAnd, itemSData.NameZh, singleRewardInfo.num)
              end
            end
          end
        end
      end
    end
    singleLabel.unlock = self.isUnlock or false
    table.insert(temp.label, singleLabel)
  end
  local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
  local rewardStr = AdventureDataProxy.Instance:getUnlockRewardStr(self.data.staticData)
  local fixedAttrLabelText = unlockCondition
  if unlockCondition and unlockCondition ~= "" then
    local label = {}
    if rewardStr and rewardStr ~= "" then
      fixedAttrLabelText = string.format("%s%s%s", unlockCondition, ZhString.FunctionDialogEvent_And, rewardStr)
      label.text = fixedAttrLabelText
      label.unlock = self.isUnlock or false
      table.insert(temp.label, label)
    end
  end
  local intoPackageRewardStr = AdventureDataProxy.Instance:getIntoPackageRewardStr(self.data.staticData)
  local propertyUnlock = string.format(ZhString.ItemTip_UnlockProperyRewardTip, self.data:GetName())
  local strIsNotEmpty = intoPackageRewardStr and intoPackageRewardStr ~= ""
  if strIsNotEmpty then
    propertyUnlock = propertyUnlock .. ZhString.FunctionDialogEvent_And .. intoPackageRewardStr
  end
  if strIsNotEmpty or self.data.type ~= SceneManual_pb.EMANUALTYPE_FURNITURE then
    local singleLabel = {
      text = propertyUnlock,
      unlock = self.data.store or false
    }
    table.insert(temp.label, singleLabel)
  end
  local refineStoreAttrLabelText = AdventureDataProxy.Instance:getIntoPackageRefineRewardGroup(self.data.staticData, nil, self.data.store, self:GetRefineLv(), "[808080ff]")
  if refineStoreAttrLabelText then
    for i = 1, #refineStoreAttrLabelText do
      local singleLabel = {
        text = refineStoreAttrLabelText[i].text,
        unlock = refineStoreAttrLabelText[i].unlock
      }
      table.insert(temp.label, singleLabel)
    end
  end
  temp.hideline = true
  if not self.data.store and not self.isUnlock then
    temp.tiplabel = ZhString.MonsterTip_LockProperyReward
  else
    temp.tiplabel = ZhString.MonsterTip_LockProperyReward
  end
  return temp
end

function ItemTipModelCell:GetRefineLv()
  local equipInfo = self.data and self.data.equipInfo
  local groupID = equipInfo and equipInfo.equipData.GroupID
  if groupID then
    return 0
  end
  for _k, v in pairs(self.data.savedItemDatas) do
    return v.equipInfo and v.equipInfo.refinelv or 0
  end
  return 0
end

function ItemTipModelCell:GetEquipProp()
  local equipInfo = self.data.equipInfo
  if equipInfo and self.data.type ~= SceneManual_pb.EMANUALTYPE_TOY then
    local uniqueEffect = equipInfo:GetUniqueEffect()
    if uniqueEffect and 0 < #uniqueEffect then
      local special = {}
      special.label = {}
      special.hideline = true
      special.tiplabel = ZhString.MonsterTip_EquipInfo
      local label = ""
      for i = 1, #uniqueEffect do
        local id = uniqueEffect[i].id
        label = label .. self:FormatBufferStr(id) .. "\n"
      end
      if label ~= "" then
        label = string.sub(label, 1, -2)
        table.insert(special.label, {text = label})
        return special
      end
    end
  end
end

function ItemTipModelCell:GetItemDesc()
  local sData = self.data.staticData
  if not self.data.cardInfo and sData.Desc ~= "nil" and sData.Desc ~= "" and self.isUnlock then
    local desc = {}
    if self.data.cup_name then
      desc.label = string.format(sData.Desc, self.data.cup_name)
    else
      desc.label = sData.Desc
    end
    desc.hideline = true
    return desc
  end
end

function ItemTipModelCell:GetItemUnlock()
  local advReward = self.data.staticData.AdventureReward
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local temp = {
      tiplabel = ZhString.MonsterTip_LockReward
    }
    temp.label = {}
    local singleLabel = {
      text = AdventureDataProxy.getUnlockCondition(self.data) .. "，" .. "{uiicon=Adventure_icon_05}x" .. self.data.staticData.AdventureValue
    }
    local rewardTeams = advReward and advReward.rewardid
    if rewardTeams then
      local tbItem = Table_Item
      local rewardItemsInfo, itemSData
      for _, teamId in pairs(rewardTeams) do
        rewardItemsInfo = ItemUtil.GetRewardItemIdsByTeamId(teamId)
        if rewardItemsInfo then
          for _, singleRewardInfo in pairs(rewardItemsInfo) do
            if singleRewardInfo.type == 1 then
              itemSData = tbItem[singleRewardInfo.id]
              if itemSData then
                singleLabel.text = string.format("%s%s%sx%s", singleLabel.text, ZhString.ItemTip_ChAnd, itemSData.NameZh, singleRewardInfo.num)
              end
            end
          end
        end
      end
    end
    singleLabel.unlock = self.isUnlock or false
    table.insert(temp.label, singleLabel)
    temp.hideline = true
    temp.labelType = AdventureDataProxy.LabelType.Status
    return temp
  end
end

function ItemTipModelCell:getMakeMaterial()
  local table_ItemBeTransformedWay = EquipMakeProxy.Instance:GetBeTransformedWayTable()
  if not self.data.cardInfo and table_ItemBeTransformedWay[self.data.staticId] then
    local cid = table_ItemBeTransformedWay[self.data.staticId]
    local table_compose = EquipMakeProxy.Instance:GetComposeTable()
    local composeData = table_compose[cid]
    if composeData then
      local costItem = composeData.BeCostItem
      local temp = {
        labelType = AdventureDataProxy.LabelType.Count
      }
      temp.hideline = true
      temp.tiplabel = ZhString.MonsterTip_MakeMaterial
      temp.label = {}
      for i = 1, #costItem do
        local itemId = costItem[i].id
        local need = costItem[i].num
        local itemData = Table_Item[itemId]
        if itemData then
          local label = {}
          local checkBagType = BagProxy.MaterialCheckBag_Type.adventureProduce
          if self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE then
            checkBagType = BagProxy.MaterialCheckBag_Type.Furniture
          end
          local bagtype = BagProxy.Instance:Get_PackageMaterialCheck_BagTypes(checkBagType)
          local itemDatas = BagProxy.Instance:GetMaterialItems_ByItemId(itemId, bagtype)
          local exsitNum = 0
          if itemDatas and 0 < #itemDatas then
            for j = 1, #itemDatas do
              local single = itemDatas[j]
              exsitNum = exsitNum + single.num
            end
          end
          label = {
            text = itemData.NameZh,
            exist = exsitNum,
            need = need
          }
          table.insert(temp.label, label)
        end
      end
      if #temp.label > 0 then
        return temp
      end
    end
  end
end

function ItemTipModelCell:UpdateGroupItems()
  local lastID = self.curSelectGroupItemCell and self.curSelectGroupItemCell.staticId
  self.curSelectGroupItemCell = nil
  self:ClearLTGroupItem()
  local groupEquipDatas = self:GetGroupEquipArray()
  if groupEquipDatas then
    self.listGroupItems:ResetDatas(groupEquipDatas)
    self.scrollGroupItems:ResetPosition()
    local found = false
    local groupCells = self.listGroupItems:GetCells()
    if lastID then
      for i = 1, #groupCells do
        if groupCells[i].staticId == lastID then
          found = true
          self:SelectGroupItemCell(groupCells[i])
          break
        end
      end
    end
    if not found then
      self:SelectGroupItemCell(groupCells[1])
    end
    self.ltReposGroupItems = TimeTickManager.Me():CreateOnceDelayTick(100, function(owner, deltaTime)
      if self.listGroupItems then
        self.listGroupItems:Layout()
      end
      if self.scrollGroupItems then
        self.scrollGroupItems:ResetPosition()
      end
      self.ltReposGroupItems = nil
    end, self)
  else
    self:UpdateSkillContext()
  end
  self.objGroupItems:SetActive(groupEquipDatas ~= nil)
  return groupEquipDatas ~= nil
end

function ItemTipModelCell:SelectGroupItemCell(groupItemCell)
  if self.curSelectGroupItemCell then
    self.curSelectGroupItemCell:SetSelect(false)
  end
  self.curSelectGroupItemCell = groupItemCell
  self.curSelectGroupItemCell:SetSelect(true)
  self.labGroupItemName.text = self.curSelectGroupItemCell.data:GetName()
  self:UpdateStoreState()
  self:UpdateSkillContext()
  self:UpdateTopModel()
end

function ItemTipModelCell:UpdateSkillContext()
  local contextDatas, itemData, store = {}
  if self.curSelectGroupItemCell then
    itemData = self.curSelectGroupItemCell.data
    store = self.curSelectGroupItemCell.store
  else
    itemData = self.data
    store = itemData.store
  end
  local staticId = itemData.staticData.id or self.data.staticId
  if itemData:IsMount() then
    local equipSData = Table_Equip and Table_Equip[staticId]
    if equipSData and equipSData.UniqueEffect and equipSData.UniqueEffect.buff then
      local equipBuffs, buffEffect = equipSData.UniqueEffect.buff
      for i = 1, #equipBuffs do
        buffEffect = Table_Buffer and Table_Buffer[equipBuffs[i]]
        buffEffect = buffEffect and buffEffect.BuffEffect
        if buffEffect and buffEffect.type == "GetSkill" then
          contextDatas[#contextDatas + 1] = {
            buffEffect.SkillID,
            store
          }
        end
      end
    end
  end
  if next(contextDatas) then
    self.skillTable:SetActive(true)
    self.skillCtl:ResetDatas(contextDatas)
    local cells = self.skillCtl:GetCells()
    cells[#cells]:HideLine(true)
    self:Show(self.UseEffectSkill)
    if store then
      self:SetTextureWhite(self.UseEffectSkill)
      self.UseEffectSkill:GetComponent(BoxCollider).enabled = true
      self.labUseEffectSkill.effectColor = labEffectColor
    else
      self:SetTextureGrey(self.UseEffectSkill)
      self.UseEffectSkill:GetComponent(BoxCollider).enabled = false
    end
  else
    self.skillTable:SetActive(false)
    self:Hide(self.UseEffectSkill)
  end
  self.BottomGrid:Reposition()
  self.skillTable2:Reposition()
  self.skillTable1:Reposition()
  self.centerTable:Reposition()
end

function ItemTipModelCell:UpdateAttriContext()
  self.attriCtl:ResetDatas()
  local contextDatas = {}
  local sData = self.data.staticData
  if self.data:IsWeapon() or self.data:IsShield() then
    local equipInfo = self.data.equipInfo
    local singleData = self:GetItemDesc()
    if singleData then
      table.insert(contextDatas, singleData)
    end
    singleData = ItemTipBaseCell.GetEquipDecomposeTip(equipInfo)
    if singleData then
      singleData.hideline = true
      table.insert(contextDatas, singleData)
    end
    singleData = ItemTipBaseCell.GetItemType(sData)
    if singleData then
      singleData.hideline = true
      table.insert(contextDatas, singleData)
    end
    singleData = ItemTipBaseCell.GetEquipBaseAttriByItemData(self.data, true)
    if singleData then
      singleData.hideline = true
      table.insert(contextDatas, singleData)
    end
    singleData = ItemTipBaseCell.GetEquipSpecial(equipInfo, true)
    if singleData then
      singleData.hideline = true
      table.insert(contextDatas, singleData)
    end
    singleData = ItemTipBaseCell.GetEquipPvpBaseAttri(equipInfo, true)
    if singleData then
      singleData.hideline = true
      table.insert(contextDatas, singleData)
    end
    singleData = ItemTipBaseCell.GetEquipProfession(equipInfo)
    if singleData then
      singleData.hideline = true
      table.insert(contextDatas, singleData)
    end
  else
    local desc = self:GetItemDesc()
    if desc then
      table.insert(contextDatas, desc)
    end
    local equipProp = self:GetEquipProp()
    if equipProp then
      table.insert(contextDatas, equipProp)
    end
    if self.data:IsMount() then
      local speed = ItemTipBaseCell.GetSpeedUp()
      if 0 < speed then
        local bdesc = {
          label = string.format(ZhString.ItemTip_MountSpeedUp, speed * 100)
        }
        table.insert(contextDatas, bdesc)
      end
    end
    local detailProp = self:GetItemDetail()
    if detailProp then
      table.insert(contextDatas, detailProp)
    end
    if self.data.type ~= SceneManual_pb.EMANUALTYPE_MOUNT then
      local makeMaterial = self:getMakeMaterial()
      if makeMaterial then
        table.insert(contextDatas, makeMaterial)
      end
    end
  end
  self.attriCtl:ResetDatas(contextDatas)
end

function ItemTipModelCell:GetGroupEquipArray()
  self:ClearGroupEquipDatas()
  if self.data.type ~= SceneManual_pb.EMANUALTYPE_MOUNT and self.data.type ~= SceneManual_pb.EMANUALTYPE_FASHION then
    return nil
  end
  local equipInfo = self.data and self.data.equipInfo
  local groupID = equipInfo and equipInfo.equipData.GroupID
  local equipStaticDatas = groupID and AdventureDataProxy.Instance:GetFashionGroupEquipsByGroupId(groupID)
  if not equipStaticDatas or #equipStaticDatas < 2 then
    return nil
  end
  self.groupItemDatas = ReusableTable.CreateArray()
  local isStored, equipData, groupItemData
  for i = 1, #equipStaticDatas do
    equipData = equipStaticDatas[i]
    if equipData.id ~= self.data.staticData.id then
      isStored = false
      groupItemData = ReusableTable.CreateTable()
      for i = 1, #self.data.savedItemDatas do
        if self.data.savedItemDatas[i].staticData.id == equipData.id then
          isStored = true
          groupItemData.itemData = self.data.savedItemDatas[i]
          break
        end
      end
      if not isStored then
        groupItemData.itemData = ItemData.new("AdventureGroupItem" .. equipData.id, equipData.id)
      end
      groupItemData.type = self.data.type
      groupItemData.store = isStored
      groupItemData.isUnlock = self.isUnlock
      self.groupItemDatas[#self.groupItemDatas + 1] = groupItemData
    end
  end
  if 2 > #self.groupItemDatas then
  end
  return self.groupItemDatas
end

function ItemTipModelCell:ClearGroupEquipDatas()
  if not self.groupItemDatas then
    return
  end
  for i = 1, #self.groupItemDatas do
    ReusableTable.DestroyAndClearTable(self.groupItemDatas[i])
  end
  ReusableTable.DestroyAndClearArray(self.groupItemDatas)
  self.groupItemDatas = nil
end

function ItemTipModelCell:UpdateTopInfo(data)
  local data = data or self.data
  if data then
    local qInt = data.staticData.Quality
    if self.equipTip then
      self.equipTip:SetActive(data.equiped == 1)
    end
    self:UpdateGetPathBtn(data)
    local refinelv = self:GetRefineLv()
    self.ItemName.text = (0 < refinelv and "+" .. refinelv or "") .. data:GetName()
  end
end

function ItemTipModelCell:UpdateGetPathBtn(data)
  if self.getPathBtn then
    local sId = (not self.curSelectGroupItemCell or not self.curSelectGroupItemCell.staticId) and self.data and self.data.staticId
    if sId then
      local gainData = GainWayTipProxy.Instance:GetDataByStaticID(sId)
      if GainWayTipProxy.V1 then
        self.getPathBtn:SetActive(gainData ~= nil and 0 < #gainData)
      else
        self.getPathBtn:SetActive(gainData ~= nil and 0 < #gainData.datas)
      end
    end
  end
end

function ItemTipModelCell:UpdateTopModel(chooseState)
  local staticId = self.curSelectGroupItemCell and self.curSelectGroupItemCell.data.staticData.id or self.data.staticId
  if self.curModelStaticID == staticId then
    return
  end
  self.curModelStaticID = staticId
  UIMultiModelUtil.Instance:RemoveModels()
  UIMultiModelUtil.Instance:ResetModelCell()
  self.model = nil
  self.model_Fashion2 = nil
  self.model_Fashion3 = nil
  if self.cardCell then
    self.cardCell:SetData()
  end
  self:Show3DModel(function(success)
    if not success then
      self:Show2DCell(chooseState)
    end
  end)
end

function ItemTipModelCell:ResetTopCell()
  if self.cardCell then
    self.cardCell.gameObject:SetActive(false)
  end
  self.modelHodler:SetActive(false)
  self.objNoPreview:SetActive(true)
  self.curModelStaticID = nil
end

function ItemTipModelCell:Show2DCell(chooseState)
  local nextPos = LuaGeometry.Const_V3_zero
  local cardInfo = self.data.cardInfo
  if cardInfo and self.cardCell then
    local path = ResourcePathHelper.ResourcePath(PictureManager.Config.Pic.Card .. self.data.cardInfo.Picture)
    local fileExist = Game.AssetLoadEventDispatcher:IsFileExist(path)
    if chooseState == nil then
      chooseState = fileExist == 0
    elseif fileExist == 0 then
      chooseState = true
    end
    self.cardCell:SetData(self.data, chooseState)
    nextPos = LuaGeometry.GetTempVector3(0, -310, 0)
    self.showCard = true
  end
  return nextPos
end

function ItemTipModelCell:Show3DModel(callBack)
  local data = self.data
  if data and data.staticData then
    local type = data.staticData.Type
    local key = TableUtil.FindKeyByValue(GameConfig.ManualShowItemType, type)
    if key then
      if self.data.type == SceneManual_pb.EMANUALTYPE_TOY then
        self:SetToyModel(data, function(result)
          self:Show3DModelCallBack(callBack, result)
        end)
      elseif self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE then
        self:SetNormalModel(data, function(result)
          self:Show3DModelCallBack(callBack, result)
        end)
      elseif data.equipInfo and data.equipInfo.equipData then
        local ismount = data:IsMount()
        if ismount then
          self:SetMountModel(data, function(result)
            self:Show3DModelCallBack(callBack, result)
          end)
        elseif self.data.tabData.id == 1045 and data.equipInfo.equipData.GroupID then
          self:Show3DModelCallBack(callBack, self:SetFashionModel(data))
        else
          self:SetNormalModel(data, function(result)
            self:Show3DModelCallBack(callBack, result)
          end)
        end
      elseif self.data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE then
        self:SetNormalModel(data, function(result)
          self:Show3DModelCallBack(callBack, result)
        end)
      elseif callBack then
        callBack(false)
      end
    end
  end
end

function ItemTipModelCell:Show3DModelCallBack(callBack, success)
  self.objitemmodeltexture:SetActive(success == true)
  self.objNoPreview:SetActive(not success)
  if callBack then
    callBack(success)
  end
end

function ItemTipModelCell:SetMountModel(data, callBack)
  local sData = data.staticData
  local staticId = self.curSelectGroupItemCell and self.curSelectGroupItemCell.data.staticData.id or ItemUtil.getFashionItemRoleBodyPart(data.staticId, MyselfProxy.Instance:GetMySex() == 1).id
  if self.modelId == staticId then
    return
  end
  UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
  self.modelId = staticId
  self.model = UIModelUtil.Instance:SetMountModelTexture(self.itemmodeltexture, staticId, sData.LoadShowSize or 0.8, function(obj, id, assetRolePart)
    if not assetRolePart then
      return
    end
    self.model = assetRolePart
    local showPos = sData.LoadShowPose
    if showPos and showPos[1] then
      LuaVector3.Better_Set(tempV3, showPos[1], showPos[2], showPos[3])
      if self.model.ResetLocalPosition then
        self.model:ResetLocalPosition(tempV3)
      elseif self.model.SetPosition then
        self.model:SetPosition(tempV3)
      end
    else
      local isfashion = BagProxy.fashionType[sData.Type]
      if isfashion then
        tempV3[2] = 0.5
        if self.model.ResetLocalPosition then
          self.model:ResetLocalPosition(tempV3)
        elseif self.model.SetPosition then
          self.model:SetPosition(tempV3)
        end
      end
    end
    local xzEulerConfig = GameConfig.ItemLoadShowRotateXZ and GameConfig.ItemLoadShowRotateXZ[self.data.staticId]
    LuaVector3.Better_Set(tempV3, xzEulerConfig and xzEulerConfig[1] or 0, sData.LoadShowRotate or 0, xzEulerConfig and xzEulerConfig[2] or 0)
    if self.model.ResetLocalEulerAngles then
      self.model:ResetLocalEulerAngles(tempV3)
    elseif self.model.SetEulerAngles then
      self.model:SetEulerAngles(tempV3)
    end
    if callBack then
      callBack(self.model ~= nil)
    end
  end, staticId)
end

function ItemTipModelCell:SetFashionModel(data)
  local id = data.staticId
  local maleEquipData, femaleEquipData
  local curEquipData = self.curSelectGroupItemCell and self.curSelectGroupItemCell.data.equipInfo and self.curSelectGroupItemCell.data.equipInfo.equipData
  if curEquipData then
    local otherEquipID = Game.Config_EquipGender[self.curSelectGroupItemCell.data.staticData.id]
    local otherEquipData = otherEquipID and Table_Equip[otherEquipID]
    if not curEquipData.SexEquip or curEquipData.SexEquip == 1 then
      maleEquipData = curEquipData
      if otherEquipData and (not otherEquipData.SexEquip or otherEquipData.SexEquip == 2) then
        femaleEquipData = otherEquipData
      end
    elseif curEquipData.SexEquip == 2 then
      femaleEquipData = curEquipData
      if otherEquipData and (not otherEquipData.SexEquip or otherEquipData.SexEquip == 1) then
        maleEquipData = otherEquipData
      end
    end
  end
  maleEquipData = maleEquipData or ItemUtil.getFashionItemRoleBodyPart(id, true)
  femaleEquipData = femaleEquipData or ItemUtil.getFashionItemRoleBodyPart(id)
  local args, parts = self:getArgsAndParts(true, nil, maleEquipData)
  self.model_Fashion2 = UIMultiModelUtil.Instance:SetModels(2, args)
  UIMultiModelUtil.Instance:PlayAction(2, "wait", true)
  Asset_Role.DestroyPartArray(parts)
  args, parts = self:getArgsAndParts(false, nil, femaleEquipData)
  self.model_Fashion3 = UIMultiModelUtil.Instance:SetModels(3, args)
  UIMultiModelUtil.Instance:PlayAction(3, "wait", true)
  Asset_Role.DestroyPartArray(parts)
  return true
end

function ItemTipModelCell:getArgsAndParts(isMale, prosfession, equipData)
  local displayRace = MyselfProxy.Instance:GetMyRace()
  local forceHuman = equipData and displayRace ~= 1 and not equipData.Body[displayRace]
  if forceHuman then
    displayRace = 1
  end
  local parts = Asset_Role.CreatePartArray()
  local partIndex = Asset_Role.PartIndex
  local partIndexEx = Asset_Role.PartIndexEx
  parts[partIndexEx.HairColorIndex] = self.userdata:Get(UDEnum.HAIRCOLOR) or 0
  parts[partIndexEx.BodyColorIndex] = self.userdata:Get(UDEnum.CLOTHCOLOR) or 0
  if not forceHuman then
    if equipData and equipData.RealShowModel and equipData.RealShowModel == 2 then
      parts[partIndexEx.Eye] = 2
    else
      parts[partIndex.Eye] = self.userdata:Get(UDEnum.EYE) or 0
    end
    parts[partIndexEx.EyeColorIndex] = self.userdata:Get(UDEnum.EYECOLOR) or 0
  end
  TableUtility.TableClear(tempTable)
  tempTable[1] = parts
  tempTable[2] = self.itemmodeltexture
  if not prosfession or not Table_Class[prosfession] then
    prosfession = 1
  end
  if isMale then
    parts[partIndex.Body] = equipData and equipData.Body[displayRace] or Table_Class[prosfession].MaleBody
    parts[partIndex.Hair] = displayRace == 1 and 2 or 93
    if displayRace == 1 then
      if equipData and equipData.RealShowModel and equipData.RealShowModel == 2 then
        parts[partIndex.Eye] = 2
      else
        parts[partIndex.Eye] = 1
      end
    elseif displayRace == 2 then
      if equipData and equipData.RealShowModel and equipData.RealShowModel == 2 then
        parts[partIndex.Eye] = 4
      else
        parts[partIndex.Eye] = 3
      end
    end
    if forceHuman then
      parts[partIndexEx.EyeColorIndex] = 0
    end
    tempTable[3] = ItemTipModelCell.ModelPos[1].position
    tempTable[4] = ItemTipModelCell.ModelPos[1].rotation
  else
    parts[partIndex.Body] = equipData and equipData.Body[displayRace] or Table_Class[prosfession].FemaleBody
    parts[partIndex.Hair] = displayRace == 1 and 14 or 87
    if displayRace == 1 then
      if equipData and equipData.RealShowModel and equipData.RealShowModel == 1 then
        parts[partIndex.Eye] = 1
      else
        parts[partIndex.Eye] = 2
      end
    elseif displayRace == 2 then
      if equipData and equipData.RealShowModel and equipData.RealShowModel == 1 then
        parts[partIndex.Eye] = 3
      else
        parts[partIndex.Eye] = 4
      end
    end
    if forceHuman then
      parts[partIndexEx.EyeColorIndex] = 0
    end
    tempTable[3] = ItemTipModelCell.ModelPos[2].position
    tempTable[4] = ItemTipModelCell.ModelPos[2].rotation
  end
  tempTable[5] = 1
  return tempTable, parts
end

function ItemTipModelCell:SetNormalModel(data, callBack)
  if self.data.type == SceneManual_pb.EMANUALTYPE_FURNITURE then
    if self.modelId == data.staticId then
      return
    end
    self.modelId = data.staticId
    if self.data:IsFurniture() then
      UIModelUtil.Instance:SetFurnitureModelTexture(self.itemmodeltexture, self.data.staticId, nil, function(obj)
        self.model = obj
        if callBack then
          callBack(self.model ~= nil)
        end
      end)
    elseif self.data:IsHomeMaterial() then
      UIModelUtil.Instance:SetHomeMaterialModelTexture(self.itemmodeltexture, self.data.staticId, nil, function(obj)
        self.model = obj
        if callBack then
          callBack(self.model ~= nil)
        end
      end)
    end
    return
  end
  local sData = data.staticData
  if self.data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE then
    local staicId = data.staticId
    local modelId
    for k, v in pairs(Table_HairStyle) do
      if staicId == v.ItemID then
        modelId = k
        break
      end
    end
    if self.modelId == modelId then
      return
    end
    self.modelId = modelId
    local partIndex = Asset_Role.PartIndex.Hair
    UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, partIndex, self.modelId, nil, function(obj, id, assetRolePart)
      self.model = assetRolePart
      local showPos = sData.LoadShowPose
      if showPos and showPos[1] then
        self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
      else
        local isfashion = BagProxy.fashionType[sData.Type]
        if isfashion then
          self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(0, 0.5))
        end
      end
      local xzEulerConfig = GameConfig.ItemLoadShowRotateXZ and GameConfig.ItemLoadShowRotateXZ[self.data.staticId]
      self.model:ResetLocalEulerAnglesXYZ(xzEulerConfig and xzEulerConfig[1] or 0, sData.LoadShowRotate or 0, xzEulerConfig and xzEulerConfig[2] or 0)
      local size = sData.LoadShowSize or 2
      self.model:ResetLocalScale(LuaGeometry.GetTempVector3(size, size, size))
      if callBack then
        callBack(self.model ~= nil)
      end
    end)
    return
  end
  local npcCfg = GameConfig.Item2Npc
  local npcID = npcCfg and npcCfg[self.data.staticId]
  if npcID then
    self:ShowNpcModel(npcID, callBack)
    return
  end
  local GroupID = data.equipInfo and data.equipInfo.equipData.GroupID
  if GroupID then
    local equipDatas = AdventureDataProxy.Instance.fashionGroupData[GroupID]
    if not equipDatas or #equipDatas == 0 then
      if callBack then
        callBack(false)
      end
      return
    end
    sData = Table_Item[self.curSelectGroupItemCell.staticId]
  end
  if self.modelId == sData.id then
    return
  end
  local partIndex = ItemUtil.getItemRolePartIndex(sData.id)
  self.modelId = sData.id
  UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, partIndex, sData.id, nil, function(obj, id, assetRolePart)
    self.model = assetRolePart
    local showPos = sData.LoadShowPose
    if showPos and showPos[1] then
      self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(showPos[1], showPos[2], showPos[3]))
    else
      local isfashion = BagProxy.fashionType[sData.Type]
      if isfashion then
        self.model:ResetLocalPosition(LuaGeometry.GetTempVector3(0, 0.5))
      end
    end
    local xzEulerConfig = GameConfig.ItemLoadShowRotateXZ and GameConfig.ItemLoadShowRotateXZ[self.data.staticId]
    self.model:ResetLocalEulerAnglesXYZ(xzEulerConfig and xzEulerConfig[1] or 0, sData.LoadShowRotate or 0, xzEulerConfig and xzEulerConfig[2] or 0)
    local size = sData.LoadShowSize or 2
    self.model:ResetLocalScale(LuaGeometry.GetTempVector3(size, size, size))
    if callBack then
      callBack(self.model ~= nil)
    end
  end, sData.id)
end

function ItemTipModelCell:ShowNpcModel(id, callBack)
  local sdata = Table_Npc[id]
  if not sdata then
    if callBack then
      callBack(false)
    end
    return
  end
  local otherScale = 1
  if sdata.Shape then
    otherScale = GameConfig.UIModelScale[sdata.Shape] or 1
  else
    helplog(string.format("Npc:%s Not have Shape", sdata.id))
  end
  if sdata.Scale then
    otherScale = sdata.Scale
  end
  self.modelId = sdata.id
  if self.model then
    self.model:Destroy()
  end
  UIModelUtil.Instance:SetNpcModelTexture(self.itemmodeltexture, sdata.id, nil, function(rolePart, dataID)
    if self.modelId ~= dataID then
      return
    end
    self.model = rolePart
    if self.model then
      local showPos = sdata.LoadShowPose
      if showPos and #showPos == 3 then
        self.model:SetPosition(LuaGeometry.GetTempVector3(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0))
      end
      if sdata.LoadShowRotate then
        self.model:SetEulerAngleY(sdata.LoadShowRotate)
      end
      if sdata.LoadShowSize then
        otherScale = sdata.LoadShowSize
      end
      self.model:SetScale(otherScale)
    end
    if callBack then
      callBack(self.model ~= nil)
    end
  end, sdata.id)
end

function ItemTipModelCell:SetToyModel(data, callBack)
  if self.data.type ~= SceneManual_pb.EMANUALTYPE_TOY then
    if callBack then
      callBack(false)
    end
    return
  end
  UIModelUtil.Instance:ChangeBGMeshRenderer("Bg_beijing", self.itemmodeltexture)
  local bodyConfig = GameConfig.AdventureToyBodyConfig[self.data.staticId]
  if bodyConfig then
    local bodyID = bodyConfig[1]
    local cameraConfig = bodyConfig[2]
    self.modelId = bodyID
    UIModelUtil.Instance:SetRolePartModelTexture(self.itemmodeltexture, Asset_Role.PartIndex.Body, bodyID, nil, function(rolePart, id, assetRolePart)
      self.model = assetRolePart
      local showPos = cameraConfig.LoadShowPose
      if showPos and #showPos == 3 then
        self.model:ResetLocalPositionXYZ(showPos[1] or 0, showPos[2] or 0, showPos[3] or 0)
      end
      local size = cameraConfig.LoadShowSize or 1
      self.model:ResetLocalScaleXYZ(size, size, size)
      local xzEulerConfig = GameConfig.ItemLoadShowRotateXZ and GameConfig.ItemLoadShowRotateXZ[self.data.staticId]
      self.model:ResetLocalEulerAngles(LuaGeometry.GetTempVector3(xzEulerConfig and xzEulerConfig[1] or 0, cameraConfig.LoadShowRotate or 0, xzEulerConfig and xzEulerConfig[2] or 0))
      if callBack then
        callBack(self.model ~= nil)
      end
    end, bodyID)
    return
  end
  local pathConfig = GameConfig.AdventureToyPathConfig[self.data.staticId]
  if not pathConfig or not pathConfig.Path then
    if callBack then
      callBack(false)
    end
    return
  end
  self.modelId = pathConfig.Path
  if self.model then
    self.model:Destroy()
  end
  UIModelUtil.Instance:SetModelTextureByPath(self.itemmodeltexture, pathConfig.Path, EffectHandle, function(obj)
    if not obj then
      if callBack then
        callBack(false)
      end
      return
    end
    if self.modelId ~= pathConfig.Path then
      GameObject.Destroy(obj)
      return
    end
    self.model = obj
    local tsfModel = self.model.transform
    local posConfig = pathConfig.LoadShowPose
    if posConfig and #posConfig == 3 then
      tsfModel.localPosition = LuaGeometry.GetTempVector3(posConfig[1], posConfig[2], posConfig[3])
    end
    local sizeConfig = pathConfig.LoadShowSize or 1
    tsfModel.localScale = LuaGeometry.GetTempVector3(sizeConfig, sizeConfig, sizeConfig)
    local xzEulerConfig = GameConfig.ItemLoadShowRotateXZ and GameConfig.ItemLoadShowRotateXZ[self.data.staticId]
    tsfModel.localEulerAngles = LuaGeometry.GetTempVector3(xzEulerConfig and xzEulerConfig[1] or 0, pathConfig.LoadShowRotate or 0, xzEulerConfig and xzEulerConfig[2] or 0)
    if callBack then
      callBack(self.model ~= nil)
    end
  end)
end

function ItemTipModelCell:ShowFashionPreview()
  local prosfession = MyselfProxy.Instance:GetMyProfession()
  prosfession = (self.data:IsWeapon() or self.data:IsShield()) and not self.data.equipInfo:CanUseByProfess(prosfession) and self.data.equipInfo.professCanUse ~= nil and next(self.data.equipInfo.professCanUse) or prosfession
  if self.sfp then
    self.sfp:OnExit()
  end
  local staticId = self.curSelectGroupItemCell and self.curSelectGroupItemCell.data.staticData.id or self.data.staticId
  local partBody = ItemUtil.getExactFashionItemRoleBodyPart(staticId)
  local sex = partBody.RealShowModel or MyselfProxy.Instance:GetMySex()
  if partBody then
    self.sfp = FashionPreviewTip.new(self.dropContainer)
    if sex ~= MyselfProxy.Instance:GetMySex() or prosfession ~= MyselfProxy.Instance:GetMyProfession() then
      local temp, parts = self:getArgsAndParts(sex == 1, prosfession, partBody)
      local customData = {
        parts = parts,
        class = prosfession,
        sex = sex
      }
      self.sfp:SetData(partBody.id, customData)
    else
      self.sfp:SetData(partBody.id)
    end
  end
end

function ItemTipModelCell:ClearLTGroupItem()
  if self.ltReposGroupItems then
    self.ltReposGroupItems:Destroy()
    self.ltReposGroupItems = nil
  end
end

function ItemTipModelCell:OnExit()
  if self.skillCtl then
    self.skillCtl:ResetDatas()
  end
  local chooseState
  if self.cardCell then
    chooseState = self.cardCell.use
    self.cardCell:SetData()
  end
  if self.sfp then
    self.sfp:OnExit()
    self.sfp = nil
  end
  if self.gainwayCtl then
    self.gainwayCtl:OnExit()
    self.gainwayCtl = nil
  end
  self:ClearLTGroupItem()
  self.skillCtl:ResetDatas()
  self.attriCtl:ResetDatas()
  self.listGroupItems:ResetDatas()
  self:ClearGroupEquipDatas()
  PictureManager.Instance:UnLoadUI(texName_NoPreviewBG, self.texNoPreviewBG)
  PictureManager.Instance:UnLoadUI(texName_NoPreviewCat, self.texNoPreviewCat)
  UIModelUtil.Instance:ResetTexture(self.itemmodeltexture)
  self.curModelStaticID = nil
  UIMultiModelUtil.Instance:RemoveModels()
  UIMultiModelUtil.Instance:ResetModelCell()
  return chooseState
end

function ItemTipModelCell:ItemUpdate()
  if self.data then
    self:UpdateAttriContext()
  end
end
