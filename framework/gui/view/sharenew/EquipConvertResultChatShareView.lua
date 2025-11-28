EquipConvertResultChatShareView = class("EquipConvertResultChatShareView", BaseView)
autoImport("PhotographResultPanel")
EquipConvertResultChatShareView.ViewType = UIViewType.ShareLayer

function EquipConvertResultChatShareView:Init()
  self:initView()
  self:initData()
end

function EquipConvertResultChatShareView:initView()
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
    lbl.text = GameConfig.Share.Sharetitle[ESHAREMSGTYPE.ESHARE_NEW_EQUIP]
  end
  local rologo = self:FindGO("Logo")
  local texName = GameConfig.Share.Logo
  local logoTex = rologo:GetComponent(UITexture)
  PictureManager.Instance:SetPlayerRefluxTexture(texName, logoTex)
  self:AddButtonEvent("BgClick", function(go)
    self:CloseSelf()
  end)
  self:GetGameObjects()
  self:RegisterButtonClickEvent()
end

function EquipConvertResultChatShareView:ShareToGlobalChannel()
end

function EquipConvertResultChatShareView:FormatBufferStr(bufferId)
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

function EquipConvertResultChatShareView:setItemProperty(data)
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

function EquipConvertResultChatShareView:OnEnter()
  self:SetData(self.viewdata.viewdata.data)
  local parent = self.Container.transform
  local effectPath = ResourcePathHelper.EffectCommon("EquipConvertResultChatShareView")
  self.focusEffect = Game.AssetManager_UI:CreateAsset(effectPath, parent)
  self.itemCell:SetData(self.viewdata.viewdata.data)
end

function EquipConvertResultChatShareView:SetData(data)
  self.data = data
  self:Show(self.Container)
  self.itemName.text = data.staticData.NameZh
  self:Show(self.objBgCt)
  self:Show(self.refineBg)
  self:setItemProperty(data)
end

function EquipConvertResultChatShareView:InitItemCell(container)
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

function EquipConvertResultChatShareView:GetGameObjects()
end

function EquipConvertResultChatShareView:RegisterButtonClickEvent()
end

function EquipConvertResultChatShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function EquipConvertResultChatShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function EquipConvertResultChatShareView:OnExit()
end
