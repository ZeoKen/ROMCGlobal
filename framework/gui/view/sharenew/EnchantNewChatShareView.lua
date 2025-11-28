EnchantNewChatShareView = class("EnchantNewChatShareView", BaseView)
autoImport("PhotographResultPanel")
EnchantNewChatShareView.ViewType = UIViewType.ShareLayer

function EnchantNewChatShareView:Init()
  self:initView()
  self:initData()
end

function EnchantNewChatShareView:initView()
  self.objHolder = self:FindGO("objHolder")
  self.itemName = self:FindComponent("itemName", UILabel)
  self.Title = self:FindComponent("Title", UILabel)
  self.Container = self:FindGO("Container")
  self:InitItemCell(self.objHolder)
  self.objBgCt = self:FindGO("objBgCt")
  self.refineBg = self:FindGO("refineBg", self.objBgCt)
  self.closeBtn = self:FindGO("CloseButton")
  self.screenShotHelper = self.gameObject:GetComponent(ScreenShotHelper)
  self.ShareDescription = self:FindComponent("ShareDescription", UILabel)
  self.grid = self:FindComponent("Grid", UIGrid)
  self.gridTrans = self.grid.transform
  self.gridPosX = LuaGameObject.GetLocalPosition(self.gridTrans)
  self.attrGOs, self.attrNames, self.attrValues, self.attrMaxTips = {}, {}, {}, {}
  local go
  for i = 1, 3 do
    go = self:FindGO("Attr" .. i)
    self.attrGOs[i] = go
    self.attrNames[i] = self:FindComponent("AttrName", UILabel, go)
    self.attrValues[i] = self:FindComponent("AttrValue", UILabel, go)
    self.attrMaxTips[i] = self:FindGO("MaxTip", go)
  end
  self.combineAttr = self:FindGO("CombineAttr")
  self.combineAttrName = self:FindComponent("CombineAttrName", UILabel)
  local myName = self:FindGO("myName"):GetComponent(UILabel)
  myName.text = self.viewdata.viewdata.name
  local serverName = self:FindGO("ServerName"):GetComponent(UILabel)
  local curServer = FunctionLogin.Me():getCurServerData()
  local serverID = curServer and curServer.name or 1
  serverName.text = serverID
  if BranchMgr.IsJapan() then
    myName.gameObject:SetActive(false)
    serverName.gameObject:SetActive(false)
    local bg_name = self:FindGO("bg_name")
    if bg_name then
      bg_name:SetActive(false)
    end
  end
  local title = self:FindGO("Title")
  if title then
    local lbl = title:GetComponent(UILabel)
    lbl.text = GameConfig.Share.Sharetitle[ESHAREMSGTYPE.ESHARE_ENCHANT]
  end
  self:AddButtonEvent("BgClick", function(go)
    self:CloseSelf()
  end)
  local rologo = self:FindGO("Logo")
  local texName = GameConfig.Share.Logo
  local logoTex = rologo:GetComponent(UITexture)
  PictureManager.Instance:SetPlayerRefluxTexture(texName, logoTex)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
end

function EnchantNewChatShareView:ShareToGlobalChannel()
end

function EnchantNewChatShareView:FormatBufferStr(bufferId)
  local str = ItemUtil.getBufferDescById(bufferId)
  local result = ""
  local bufferStrs = string.split(str, "\n")
  for m = 1, #bufferStrs do
    local buffData = Table_Buffer[bufferId]
    local buffStr = ""
    if buffData then
      buffStr = string.format("{bufficon=%s} ", buffData.BuffIcon)
    end
    result = result .. buffStr .. bufferStrs[m] .. "\n"
  end
  if result ~= "" then
    result = string.sub(result, 1, -2)
  end
  return result
end

local valueColorStr = "[c][ffc64a]%s[-][/c]"
local maxColorStr = "[c][ff6a6a]%s[-][/c]"

function EnchantNewChatShareView:setItemProperty(data)
  local label = ""
  if data and data.equipInfo and data.equipInfo.randomEffect then
    for k, v in pairs(data.equipInfo.randomEffect) do
      local sData = Table_EquipEffect[k]
      local tAttrType, attrType = type(sData.AttrType)
      if tAttrType == "string" then
        attrType = sData.AttrType
      elseif tAttrType == "table" then
        attrType = tostring(sData.AttrType[1])
      end
      local attrConfig = Game.Config_PropName[attrType]
      local value = math.abs(v)
      local randAttr = Table_EquipEffect_t.AttrRate[sData.AttrRate]
      local isMax = false
      if randAttr and v == randAttr[#randAttr][1] then
        isMax = true
      end
      label = label .. string.format(OverSea.LangManager.Instance():GetLangByKey(sData.Dsc), string.format(valueColorStr, attrConfig.IsPercent == 1 and value * 100 .. "%" or value))
      if isMax then
        label = label .. string.format(maxColorStr, "  (MAX)")
      end
      label = label .. "\n"
    end
    self.ShareDescription.alignment = 0
  end
  if label ~= "" then
    self.ShareDescription.text = label
  else
    self.ShareDescription.text = ""
  end
end

function EnchantNewChatShareView:OnEnter()
  self:SetData(self.viewdata.viewdata)
  local parent = self.Container.transform
  local effectPath = ResourcePathHelper.EffectCommon("EnchantNewChatShareView")
  self.focusEffect = Game.AssetManager_UI:CreateAsset(effectPath, parent)
  self.itemCell:SetData(self.viewdata.viewdata.itemdata)
end

function EnchantNewChatShareView:SetData(data)
  self.data = data
  self:Show(self.Container)
  self.itemName.text = data.itemdata.staticData.NameZh
  self:Show(self.objBgCt)
  self:Show(self.refineBg)
  local flag = data ~= nil and data.enchantAttrList ~= nil and #data.enchantAttrList > 0
  self.gameObject:SetActive(flag)
  self.index = flag and data.index or nil
  if flag then
    self:UpdateAttrs(data.enchantAttrList)
    self:UpdateCombine(data.combineEffectList, data.quench)
  end
end

function EnchantNewChatShareView:InitItemCell(container)
  if not container then
    return
  end
  local cellObj = self:LoadPreferb("cell/ItemNewCell", container)
  if not cellObj then
    return
  end
  local cellTrans = cellObj.transform
  cellTrans:SetParent(container.transform, true)
  cellTrans.localPosition = LuaGeometry.Const_V3_zero
  cellTrans.localScale = LuaGeometry.GetTempVector3(1.3, 1.3, 1.3)
  self.itemCell = ItemNewCell.new(cellObj)
  self.itemCell:HideNum()
end

function EnchantNewChatShareView:GetGameObjects()
end

function EnchantNewChatShareView:RegisterButtonClickEvent()
end

function EnchantNewChatShareView:UpdateAttrs(attrs)
  local data, quality, indicator
  for i = 1, #self.attrGOs do
    data = attrs and attrs[i]
    self.attrGOs[i]:SetActive(data ~= nil)
    if data then
      self.attrNames[i].text = data.name
      self.attrValues[i].text = string.format(data.propVO.isPercent and "+%s%%" or "+%s", data.value)
      self.attrMaxTips[i]:SetActive(data.isMax)
    end
  end
end

function EnchantNewChatShareView:UpdateCombine(combineEffs, quench)
  local hasCombine, buffData = false
  if combineEffs then
    for i = 1, #combineEffs do
      buffData = combineEffs[i] and combineEffs[i].buffData
      if buffData then
        hasCombine = true
        local buffDesc = ItemUtil.GetBuffDesc(buffData.BuffDesc, quench)
        self.combineAttrName.text = combineEffs[i].isWork and string.format("%s:%s", buffData.BuffName, buffDesc) or string.format("%s:%s(%s)", buffData.BuffName, buffDesc, combineEffs[i].WorkTip)
      end
    end
  end
  self.gridTrans.localPosition = LuaGeometry.GetTempVector3(self.gridPosX, hasCombine and 52 or 41)
  self.grid.cellHeight = hasCombine and 31 or 42
  self.grid:Reposition()
  self.combineAttr:SetActive(hasCombine)
end

function EnchantNewChatShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function EnchantNewChatShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function EnchantNewChatShareView:OnExit()
end
