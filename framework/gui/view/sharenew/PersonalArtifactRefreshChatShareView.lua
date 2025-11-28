PersonalArtifactRefreshChatShareView = class("PersonalArtifactRefreshChatShareView", BaseView)
autoImport("PhotographResultPanel")
autoImport("ItemTipBaseCell")
PersonalArtifactRefreshChatShareView.ViewType = UIViewType.ShareLayer
PersonalArtifactRefreshChatShareView.ShareType = {
  NormalShare = 1,
  SkadaShare = 2,
  RaidResultShare = 3
}

function PersonalArtifactRefreshChatShareView:Init()
  self:initView()
  self:initData()
end

function PersonalArtifactRefreshChatShareView:initView()
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
    lbl.text = GameConfig.Share.Sharetitle[ESHAREMSGTYPE.ESHARE_REMOULD_ARTIFACT]
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

function PersonalArtifactRefreshChatShareView:ShareToGlobalChannel()
end

function PersonalArtifactRefreshChatShareView:setItemProperty(itemData)
  local label = ""
  local data = itemData.personalArtifactData
  if not data then
    data = PersonalArtifactData.new(itemData.staticData.id)
    if data.isInited then
      data:SetFakeData()
    end
  end
  if data.isInited then
    local s = data:GetAttriDescUniqueEffectForShare()
    if not StringUtil.IsEmpty(s) then
      label = s
    end
  end
  self.ShareDescription.alignment = 0
  if label ~= "" then
    self.ShareDescription.text = label
  else
    self.ShareDescription.text = ""
  end
end

function PersonalArtifactRefreshChatShareView:OnEnter()
  self:SetData(self.viewdata.viewdata.data)
  local parent = self.Container.transform
  local effectPath = ResourcePathHelper.EffectCommon("PersonalArtifactRefreshChatShareView")
  self.focusEffect = Game.AssetManager_UI:CreateAsset(effectPath, parent)
  self.itemCell:SetData(self.viewdata.viewdata.data)
end

function PersonalArtifactRefreshChatShareView:InitItemCell(container)
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

function PersonalArtifactRefreshChatShareView:SetData(data)
  self.data = data
  self:Show(self.Container)
  self.itemName.text = data.staticData.NameZh
  self:Show(self.objBgCt)
  self:Show(self.refineBg)
  self:setItemProperty(data)
end

function PersonalArtifactRefreshChatShareView:GetGameObjects()
end

function PersonalArtifactRefreshChatShareView:RegisterButtonClickEvent()
end

function PersonalArtifactRefreshChatShareView:changeUIState(isStart)
  if isStart then
    self:Hide(self.goUIViewSocialShare)
    self:Hide(self.closeBtn)
  else
    self:Show(self.goUIViewSocialShare)
    self:Show(self.closeBtn)
  end
end

function PersonalArtifactRefreshChatShareView:initData()
  self.screenShotWidth = -1
  self.screenShotHeight = 1080
  self.textureFormat = TextureFormat.RGB24
  self.texDepth = 24
  self.antiAliasing = ScreenShot.AntiAliasing.None
end

function PersonalArtifactRefreshChatShareView:OnExit()
end
