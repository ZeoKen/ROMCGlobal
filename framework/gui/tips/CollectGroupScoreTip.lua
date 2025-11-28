autoImport("TipLabelCell")
autoImport("ProfessionSkillCell")
CollectGroupScoreTip = class("CollectGroupScoreTip", BaseView)
CollectGroupScoreTip.BgTextureName = "com_bg_light"
CollectGroupScoreTip.UITextureName = "UI_daquan"

function CollectGroupScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("CollectGroupScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self:Init()
end

function CollectGroupScoreTip:adjustPanelDepth(startDepth)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  local minDepth
  for i = 1, #panels do
    if minDepth == nil then
      minDepth = panels[i].depth
    else
      minDepth = math.min(panels[i].depth, minDepth)
    end
  end
  startDepth = startDepth or 1
  for i = 1, #panels do
    panels[i].depth = panels[i].depth + startDepth + upPanel.depth - minDepth
  end
end

function CollectGroupScoreTip:Init()
  self:initLockBord()
  self:initView()
end

function CollectGroupScoreTip:initView()
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.modeltexture = self:FindComponent("ModelTexture", UITexture)
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  self.GroupIcon = self:FindComponent("GroupIcon", UISprite)
  self.CollectionGroupName = self:FindComponent("CollectionGroupName", UILabel)
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, AdventureTipLabelCell, "AdventureTipLabelCell")
  self.chatacterBtn = self:FindGO("ChatacterBtn")
  local btnText = self:FindComponent("Label", UILabel, self.chatacterBtn)
  btnText.text = ZhString.CollectGroupScoreTip_EDBtn
  self.recvBtn = self:FindGO("RecvBtn")
  self.recvBtnText = self:FindComponent("Label", UILabel, self.recvBtn)
  self.recvBtnText.text = ZhString.CollectGroupScoreTip_RecvBtn
  self.disabledBtn = self:FindGO("DIsabledBtn")
  self.disabledBtnText = self:FindComponent("Label", UILabel, self.disabledBtn)
  self.disabledBtnText.text = ZhString.CollectGroupScoreTip_RecvBtn
  self:AddClickEvent(self.chatacterBtn, function(go)
    ServiceSceneManualProxy.Instance:CallGroupActionManualCmd(SceneManual_pb.EGROUPACTION_ENTER_END, self.data.staticData.staticId)
  end)
  self:AddClickEvent(self.recvBtn, function()
    ServiceSceneManualProxy.Instance:CallGroupActionManualCmd(SceneManual_pb.EGROUPACTION_COLLECTION_REWARD, self.data.staticData.id)
  end)
  local itemGrid = self:FindComponent("ItemTable", UIGrid)
  self.gridList = UIGridListCtrl.new(itemGrid, AdventrueItemCell, "AdventureItemCell")
  self.gridList:AddEventListener(MouseEvent.MouseClick, self.clickHandler, self)
  self.effectContainer = self:FindComponent("EffectContainer", ChangeRqByTex)
  self.holderDepth = self:FindComponent("EffectContainer", UITexture).depth
  self.mask = self:FindGO("mask")
  self.bgTexture = self:FindComponent("BgTexture", UITexture)
  PictureManager.Instance:SetUI(CollectGroupScoreTip.BgTextureName, self.bgTexture)
  self.UITextureNameone = self:FindComponent("UI_daquan1", UITexture)
  PictureManager.Instance:SetUI(CollectGroupScoreTip.UITextureName, self.UITextureNameone)
  self.UITextureNametwo = self:FindComponent("UI_daquan2", UITexture)
  PictureManager.Instance:SetUI(CollectGroupScoreTip.UITextureName, self.UITextureNametwo)
  self.gotoBtnGO = self:FindGO("GotoBtn")
  self:AddClickEvent(self.gotoBtnGO, function()
    self:OnGotoClicked()
  end)
  self.gotoBtnIcon = self:FindComponent("Icon", UISprite, self.gotoBtnGO)
  self.gotoIconNames = {
    "map_collection",
    "map_collection2"
  }
end

function CollectGroupScoreTip:initLockBord()
  local obj = self:FindGO("13itemShine")
  self.lockBord = self:FindGO("LockBordHolder")
  if not obj then
  end
end

function CollectGroupScoreTip:OnGotoClicked()
  if not self.data then
    return
  end
  local collectionType = self.data:GetCollectionType()
  if collectionType == 1 or collectionType == 2 then
    if collectionType == 1 then
      local collectionItemData, questData = self.data:GetNextCollectionDataWithQuest()
      if questData then
        FunctionQuest.Me():executeManualQuest(questData)
        GameFacade.Instance:sendNotification(AdventurePanel.ClosePanel)
        return
      end
    end
    local mapId = self.data:GetMapId()
    if mapId and MapTeleportUtil.CanTargetTransferTo(mapId) then
      FuncShortCutFunc.Me():MoveToPos({
        Event = {mapid = mapId}
      })
      GameFacade.Instance:sendNotification(AdventurePanel.ClosePanel)
    else
      MsgManager.ShowMsgByID(43315)
    end
  end
end

function CollectGroupScoreTip:GetGotoBtnStatus()
  do return false end
  if self.data then
    local collectionType = self.data:GetCollectionType()
    if collectionType == 1 then
      if self.data:isTotalComplete() then
        return false, collectionType
      end
      local _, questData = self.data:GetNextCollectionDataWithQuest()
      if questData ~= nil then
        return true, collectionType
      end
      local mapId = self.data:GetMapId()
      if mapId and 0 < mapId then
        return true, collectionType
      end
      return false, collectionType
    elseif collectionType == 2 then
      local mapId = self.data:GetMapId()
      return not self.data:isTotalComplete() and mapId ~= nil and 0 < mapId, collectionType
    end
  end
  return false
end

function CollectGroupScoreTip:clickHandler(target)
  local data = target.data
  if data.status == SceneManual_pb.EMANUALSTATUS_UNLOCK_CLIENT then
    ServiceSceneManualProxy.Instance:CallUnlock(data.type, data.staticId)
    target:PlayUnlockEffect()
    self:PlayUISound(AudioMap.UI.maoxianshoucedianjijiesuo)
  else
    local itemData = ItemData.new(nil, data.staticId)
    local sdata = {
      itemdata = itemData,
      hideItemIcon = data.status ~= SceneManual_pb.EMANUALSTATUS_UNLOCK
    }
    self:ShowItemTip(sdata, target.bg, NGUIUtil.AnchorSide.Right, {200, 0})
  end
end

function CollectGroupScoreTip:SetData(data)
  self.data = data
  self:initData()
  self:SetLockState()
  self:adjustPanelDepth()
  self:UpdateCollections()
  self:UpdateAttriText()
  self:UpdateRecvBtn()
end

function CollectGroupScoreTip:initData()
  IconManager:SetItemIcon(self.data.staticData.Icon, self.GroupIcon)
  self.CollectionGroupName.text = self.data.staticData.Name
  if self.data.staticData and self.data.staticData.Ed == 1 then
    self:Show(self.chatacterBtn.gameObject)
  else
    self:Hide(self.chatacterBtn.gameObject)
  end
end

function CollectGroupScoreTip:SetLockState()
  self.isUnlock = false
  if self.data then
    self.isUnlock = self.data:isTotalComplete()
  end
  self.lockBord.gameObject:SetActive(not self.isUnlock)
  self.mask:SetActive(not self.isUnlock)
end

function CollectGroupScoreTip:Show3DModel()
end

function CollectGroupScoreTip:UpdateCollections()
  local data = self.data
  if data then
    local collections = self.data:getCollectionData()
    self.gridList:ResetDatas(collections)
  else
    self.gridList:ResetDatas({})
  end
end

function CollectGroupScoreTip:UpdateRecvBtn()
  local ManualData = AdventureDataProxy.Instance:GetCollectionRewardManualData(self.data.staticData.id)
  local status
  if ManualData then
    status = ManualData.status
  end
  if status == 1 then
    self.recvBtn.gameObject:SetActive(true)
    self.disabledBtn.gameObject:SetActive(false)
    self.recvBtnText.text = ZhString.CollectGroupScoreTip_RecvBtn
    self.gotoBtnGO:SetActive(false)
  elseif status == 2 then
    self.recvBtn.gameObject:SetActive(false)
    self.disabledBtn.gameObject:SetActive(true)
    self.disabledBtnText.text = ZhString.CollectGroupScoreTip_ReceivedBtn
    self.gotoBtnGO:SetActive(false)
  else
    self.recvBtn.gameObject:SetActive(false)
    self.disabledBtn.gameObject:SetActive(false)
    local shouldShow, collectionType = self:GetGotoBtnStatus()
    if shouldShow then
      self.gotoBtnGO:SetActive(true)
      local iconName = collectionType and self.gotoIconNames[collectionType]
      if iconName then
        IconManager:SetMapIcon(iconName, self.gotoBtnIcon)
      end
    else
      self.gotoBtnGO:SetActive(false)
    end
  end
end

function CollectGroupScoreTip:UpdateAttriText()
  local content = {}
  local data = self.data
  local sdata = self.data.staticData
  if data and sdata then
    local transform = self.gridList.layoutCtrl.transform
    local bound = NGUIMath.CalculateRelativeWidgetBounds(transform, false)
    local pos = transform.localPosition
    local y = pos.y - bound.size.y - 20 + 50
    if bound.size.y == 0 then
      y = pos.y + 50
    end
    self.attriCtl.layoutCtrl.transform.localPosition = LuaGeometry.GetTempVector3(-13, y, 0)
    if not self.data:isTotalComplete() then
      local unlockDesc = sdata.UnlockDesc
      if unlockDesc and unlockDesc ~= "" then
        local unlockLabelCell = {}
        unlockLabelCell.label = {}
        unlockLabelCell.hideline = true
        table.insert(unlockLabelCell.label, "[c][FF622CFF][" .. ZhString.MonsterTip_LockTitle .. "][-][/c]")
        table.insert(unlockLabelCell.label, unlockDesc)
        table.insert(content, unlockLabelCell)
      end
    end
    local rewardStr = ""
    local advReward = sdata.RewardProperty
    if sdata.RewardStr and sdata.RewardStr ~= "" and advReward then
      rewardStr = sdata.RewardStr
      local tempRewardStr = ""
      for key, value in pairs(advReward) do
        local kprop = RolePropsContainer.config[key]
        if kprop and kprop.displayName and 0 < value then
          tempRewardStr = tempRewardStr .. kprop.displayName .. " [c][9fc33dff]+" .. value .. "[-][/c] "
        end
      end
      if advReward.AdvPoints then
        tempRewardStr = tempRewardStr .. "{itemicon=451} x" .. advReward.AdvPoints
      end
      if advReward.item then
        for i = 1, #advReward.item do
          tempRewardStr = tempRewardStr .. string.format("{itemicon=%d} x%s", advReward.item[i][1], advReward.item[i][2])
        end
      end
      rewardStr = string.format(rewardStr, tempRewardStr)
    end
    if rewardStr and rewardStr ~= "" then
      tipLabelCell = {}
      tipLabelCell.label = {}
      tipLabelCell.hideline = true
      tipLabelCell.tiplabel = ZhString.MonsterTip_LockProperyReward
      tipLabelCell.labelType = AdventureDataProxy.LabelType.Status
      local currentUnlock = data:getCurrentUnlockNum()
      local total = #data.collections
      if sdata.id == 50 then
        local singleLabel = {
          text = string.format(ZhString.CollectGroupScoreTip_HeadTipSpec, rewardStr),
          unlock = self.isUnlock or false
        }
        table.insert(tipLabelCell.label, singleLabel)
      else
        local singleLabel = {
          text = string.format(ZhString.CollectGroupScoreTip_HeadTip, currentUnlock, total, rewardStr),
          unlock = self.isUnlock or false
        }
        table.insert(tipLabelCell.label, singleLabel)
      end
      content[#content + 1] = tipLabelCell
    end
    tipLabelCell = {}
    if self.isUnlock then
      tipLabelCell.label = GameConfig.ItemQualityDesc[sdata.Quality]
    else
      tipLabelCell.label = "[c][22222291]" .. GameConfig.ItemQualityDesc[sdata.Quality]
    end
    tipLabelCell.hideline = true
    tipLabelCell.tiplabel = ZhString.MonthTip_QualityRate
    content[#content + 1] = tipLabelCell
    local tipLabelCell = {}
    local desc = sdata.Desc
    if desc ~= "" then
      tipLabelCell = {}
      tipLabelCell.label = {}
      tipLabelCell.hideline = true
      tipLabelCell.tiplabel = ZhString.MonsterTip_Story
      if self.isUnlock then
        table.insert(tipLabelCell.label, desc)
      else
        table.insert(tipLabelCell.label, "？？？？？？？")
      end
      content[#content + 1] = tipLabelCell
    end
  end
  self.attriCtl:ResetDatas(content)
end

function CollectGroupScoreTip:OnExit()
  self.attriCtl:ResetDatas()
  self.gridList:ResetDatas()
  UIModelUtil.Instance:ResetTexture(self.modeltexture)
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  PictureManager.Instance:UnLoadUI(CollectGroupScoreTip.BgTextureName, self.bgTexture)
  PictureManager.Instance:UnLoadUI(CollectGroupScoreTip.UITextureName, self.UITextureNameone)
  PictureManager.Instance:UnLoadUI(CollectGroupScoreTip.UITextureName, self.UITextureNametwo)
  CollectGroupScoreTip.super.OnExit(self)
end
