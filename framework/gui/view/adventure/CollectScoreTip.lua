autoImport("BaseTip")
CollectScoreTip = class("CollectScoreTip", BaseView)
local texName_NoPreviewBG = "com_bg_scene"
local texName_NoPreviewCat = "adventure_kong"

function CollectScoreTip:ctor(parent)
  self.resID = ResourcePathHelper.UITip("CollectScoreTip")
  self.gameObject = Game.AssetManager_UI:CreateAsset(self.resID, parent)
  self.gameObject.transform.localPosition = LuaGeometry.GetTempVector3()
  self:Init()
end

function CollectScoreTip:adjustPanelDepth(startDepth)
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

function CollectScoreTip:Init()
  self.itemName = self:FindComponent("ItemName", UILabel)
  self.scrollView = self:FindComponent("ScrollView", UIScrollView)
  self.table = self:FindComponent("AttriTable", UITable)
  self.attriCtl = UIGridListCtrl.new(self.table, AdventureTipLabelCell, "AdventureTipLabelCell")
  self.adventureValue = self:FindComponent("adventureValue", UILabel)
  self.MediaPlayCt = self:FindGO("MediaPlayCt")
  self:AddButtonEvent("MediaPlay", function()
    VideoPanel.PlayVideo(self.mediaPath)
  end)
  self.UnlockReward = self:FindGO("UnlockReward")
  local appTb = self:FindComponent("AppendTable", UITable)
  self.appCtl = UIGridListCtrl.new(appTb, AdventureAppendCell, "AdventureAppendCell")
  self.ItemCell = self:FindGO("ItemCell")
  local UnlockReward = self:FindGO("UnlockReward")
  self:Hide(UnlockReward)
  self:initLockBord()
  self.objNoPreview = self:FindGO("NoPreview")
  self.texNoPreviewBG = self:FindComponent("NoPreviewBG", UITexture, self.objNoPreview)
  self.texNoPreviewCat = self:FindComponent("NoPreviewCat", UITexture, self.objNoPreview)
  PictureManager.Instance:SetUI(texName_NoPreviewBG, self.texNoPreviewBG)
  PictureManager.Instance:SetUI(texName_NoPreviewCat, self.texNoPreviewCat)
  self.dropContainer = self:FindGO("DropContainer")
  self:AddClickEvent(self.getPathBtn, function()
    local sId = self.data.staticId
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

function CollectScoreTip:adjustLockRewardPos()
  local bound = NGUIMath.CalculateRelativeWidgetBounds(self.table.transform)
  local pos = self.table.transform.localPosition
  local y = pos.y - bound.size.y - 20
  self.UnlockReward.transform.localPosition = LuaGeometry.GetTempVector3(pos.x, y, pos.z)
end

function CollectScoreTip:initLockBord()
  local obj = self:FindGO("LockBord")
  self.lockBord = self:FindGO("LockBordHolder")
  if not obj then
    obj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UIView("LockBord"), self.lockBord)
    obj.name = "LockBord"
  end
  obj.transform.localPosition = LuaGeometry.GetTempVector3()
  obj.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.sprLock = self:FindComponent("Sprite (1)", UISprite, obj)
  self.lockTipLabel = self:FindComponent("LockTipLabel", UILabel)
  
  function self.lockTipLabel.onChange()
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  
  self.getPathBtn = obj.transform:Find("getPathBtn").gameObject
  self.bottomCt = obj.transform:Find("BottomCt").gameObject
  local LockTitle = self:FindComponent("LockTitle", UILabel)
  LockTitle.text = ZhString.MonsterTip_LockTitle
  self.LockReward = self:FindComponent("LockReward", UILabel)
  self.LockReward.text = ZhString.MonsterTip_LockReward
  self.FixAttrCt = self:FindGO("FixAttrCt")
  self:Hide(self.FixAttrCt)
  self.modelBottombg = self:FindGO("modelBottombg")
end

function CollectScoreTip:SetUnlockCondition()
  self.lockTipLabel.text = self.data.staticData.NameZh
end

function CollectScoreTip:getUnlockRewardStr()
  local advReward = self.data.staticData.AdventureReward
  if type(advReward) == "table" and type(advReward.buffid) == "table" then
    local str = ""
    for i = 1, #advReward.buffid do
      local value = advReward.buffid[i]
      local bufferData = Table_Buffer[value]
      if bufferData then
        str = str .. (bufferData.Dsc or "")
        str = str .. "\n"
      end
    end
    if str ~= "" then
      str = string.sub(str, 1, -2)
    end
    return str
  end
end

function CollectScoreTip:adjustDepth(obj)
  local max = -999
  if obj then
    local objs = Game.GameObjectUtil:GetAllChildren(obj)
    for i = 1, #objs do
      local child = objs[i]
      local widget = child:GetComponent(UIWidget)
      if widget then
        widget.depth = widget.depth + 50
        if max < widget.depth then
          max = widget.depth
        end
      end
    end
  end
  return max
end

function CollectScoreTip:UpdateTopInfo()
  local data = self.data
  local sdata = data and data.staticData
  if sdata then
    self.itemName.text = sdata.NameZh
    UIUtil.FitLableMaxWidth(self.itemName, 427)
    self.itemCellCtl = ItemCell.new(self.ItemCell)
    self.itemCellCtl:SetData(self.data)
    self.mediaPath = sdata.MediaPath
    if self.mediaPath and self.mediaPath ~= "" then
      self:Show(self.MediaPlayCt)
      self:Hide(self.ItemCell)
    else
      self:Show(self.ItemCell)
      self:Hide(self.MediaPlayCt)
    end
  end
  self:UpdateGetPathBtn(data)
end

function CollectScoreTip:UpdateGetPathBtn(data)
  if self.getPathBtn and data.staticData then
    local gainData = GainWayTipProxy.Instance:GetDataByStaticID(data.staticData.id)
    self.getPathBtn:SetActive(gainData ~= nil and #gainData.datas > 0)
  end
end

function CollectScoreTip:SetData(monsterData)
  self.data = monsterData
  self:SetLockState()
  self:UpdateTopInfo()
  self:UpdateAttriText()
  self:UpdateAppendData()
  self:adjustPanelDepth(4)
  self:adjustLockRewardPos()
  self:adjustLockView()
  self:SetUnlockCondition()
end

function CollectScoreTip:adjustLockView()
end

function CollectScoreTip:SetLockState()
  self.isUnlock = false
  if self.data then
    self.isUnlock = self.data.status ~= SceneManual_pb.EMANUALSTATUS_DISPLAY
    local unlockCondition = AdventureDataProxy.getUnlockCondition(self.data)
    self.lockTipLabel.text = unlockCondition
    if self.sprLock then
      self.sprLock:ResetAndUpdateAnchors()
    end
  end
  if self.isUnlock then
    self:Show(self.modelBottombg)
  else
    self:Hide(self.modelBottombg)
  end
  self.bottomCt.gameObject:SetActive(not self.isUnlock)
end

function CollectScoreTip:GetItemUnlock()
  local advReward, advRDatas = self.data.staticData.AdventureReward, {}
  if self.data.staticData.AdventureValue and self.data.staticData.AdventureValue > 0 then
    local temp = {}
    temp.tiplabel = ZhString.MonsterTip_LockProperyReward
    temp.label = {}
    local singleLabl = {
      text = AdventureDataProxy.getUnlockCondition(self.data) .. ZhString.FunctionDialogEvent_And .. "{uiicon=Adventure_icon_05}x" .. self.data.staticData.AdventureValue,
      unlock = self.isUnlock or false
    }
    table.insert(temp.label, singleLabl)
    temp.hideline = true
    temp.labelType = AdventureDataProxy.LabelType.Status
    return temp
  end
end

function CollectScoreTip:GetItemQuality()
  if self.data.type == SceneManual_pb.EMANUALTYPE_HAIRSTYLE or self.data.type == SceneManual_pb.EMANUALTYPE_ITEM then
    return
  end
  local sdata = self.data.staticData
  if sdata then
    local desc = {}
    desc.label = GameConfig.ItemQualityDesc[sdata.Quality]
    desc.hideline = true
    desc.tiplabel = ZhString.MonthTip_QualityRate
    return desc
  end
end

function CollectScoreTip:GetItemDesc()
  local sdata = self.data.staticData
  if sdata and self.isUnlock then
    local desc = {}
    desc.label = sdata.Desc
    desc.hideline = true
    return desc
  end
end

function CollectScoreTip:UpdateAttriText()
  local contextDatas = {}
  local desc = self:GetItemDesc()
  if desc then
    table.insert(contextDatas, desc)
  end
  local quality = self:GetItemQuality()
  if quality then
    table.insert(contextDatas, quality)
  end
  local unlockProp = self:GetItemUnlock()
  if unlockProp then
    table.insert(contextDatas, unlockProp)
  end
  self.attriCtl:ResetDatas(contextDatas)
end

function CollectScoreTip:UpdateAppendData()
  if self.isUnlock then
    local trans = self.attriCtl.layoutCtrl.transform
    local bound = NGUIMath.CalculateRelativeWidgetBounds(trans, true)
    local pos = trans.localPosition
    pos = Vector3(pos.x, pos.y - bound.size.y, pos.z - 20)
    trans = self.appCtl.layoutCtrl.transform
    trans.localPosition = pos
    local appends = self.data:getNoRewardAppend()
    if 0 < #appends then
      self.appCtl:ResetDatas(appends)
    end
  end
end

function CollectScoreTip:OnExit()
  self.attriCtl:ResetDatas()
  self.appCtl:ResetDatas()
  PictureManager.Instance:UnLoadUI(texName_NoPreviewBG, self.texNoPreviewBG)
  PictureManager.Instance:UnLoadUI(texName_NoPreviewCat, self.texNoPreviewCat)
  Game.GOLuaPoolManager:AddToUIPool(self.resID, self.gameObject)
  CollectScoreTip.super.OnExit(self)
end
