local baseCell = autoImport("BaseCell")
autoImport("WishingPanelLikeCell")
WishingCardCell = class("WishingCardCell", baseCell)

function WishingCardCell:Init()
  WishingCardCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
  self:InitData()
  self:AddCellClickEvent()
end

function WishingCardCell:FindObjs()
  self.bgTexture = self:FindGO("BgTexture"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("boliwishingcard_bg", self.bgTexture)
  self.decorateCoin = self:FindGO("Decorate_Coin"):GetComponent(UITexture)
  PictureManager.Instance:SetReturnActivityTexture("returnactivity_bg_coin_03", self.decorateCoin)
  local upPanel = Game.GameObjectUtil:FindCompInParents(self.gameObject, UIPanel)
  local panels = self:FindComponents(UIPanel)
  for i = 1, #panels do
    panels[i].depth = upPanel.depth + panels[i].depth
  end
  local rootGO = self:FindGO("Root")
  self.tweenPos = rootGO:GetComponent(TweenPosition)
  self.tweenAlpha = rootGO:GetComponent(TweenAlpha)
end

function WishingCardCell:InitData()
  self.tipData = {}
  self.tipData.funcConfig = {}
end

function WishingCardCell:SetData(data)
  self:SetPage(2, data)
end

function WishingCardCell:SetPage(type, data)
  self:FindUniqueObjs(type)
  self.mainPage:SetActive(true)
  if type == 1 then
    self.title.text = ZhString.BoliWishingPanel_Title
    self.signLabel.text = Game.Myself.data:GetName()
  elseif type == 2 then
    self.id = data.id
    self.charid = data.charid
    self.liked = data.likeed
    self.likenum = data.likenum
    if self.charid ~= 0 then
      self.title.text = string.format("[u][url=%s]%s[/url][/u]", data.charid, data.charname)
    else
      self.title.text = data.charname
    end
    self.contentLabel.text = data.text
    self.contentScrollView:ResetPosition()
    if self.liked and self.likenum == 0 then
      self.likenum = 1
    end
    self.likeCount.text = self.likenum
    self.likeCount.color = self.liked and LuaGeometry.GetTempVector4(0.8901960784313725, 0.4, 0.4, 1) or LuaGeometry.GetTempVector4(0.43529411764705883, 0.43529411764705883, 0.43529411764705883, 1)
    self.likeBtn_Icon.spriteName = self.liked and "boliwishingcard_icon_01" or "boliwishingcard_icon_02"
    self:playTween()
  elseif type == 3 then
    self.nolikeTipLabel.text = ZhString.BoliWishingPanel_NoLike
    self.contentLabel.text = data.text
    self.likeCount.text = data.likenum or 0
    self.likeCount.color = data.likenum ~= 0 and LuaGeometry.GetTempVector4(0.8901960784313725, 0.4, 0.4, 1) or LuaGeometry.GetTempVector4(0.43529411764705883, 0.43529411764705883, 0.43529411764705883, 1)
    xdlog("printSize", self.contentLabel.printedSize.y)
    self.likeBtn_Icon.spriteName = data.likenum > 0 and "boliwishingcard_icon_01" or "boliwishingcard_icon_02"
    self.nolikeTipGO:SetActive(data.likenum == 0)
    self.nolikeTip.height = (250 - self.contentLabel.printedSize.y) / 2 - 50
  end
end

function WishingCardCell:FindUniqueObjs(type)
  if type == 1 then
    self.mainPage = self:FindGO("MyselfWishPage")
    self.title = self:FindGO("Title", self.mainPage):GetComponent(UILabel)
    self.signLabel = self:FindGO("SignLabel", self.mainPage):GetComponent(UILabel)
    self.contentLabel = self:FindGO("ContentLabel", self.mainPage):GetComponent(UILabel)
    self.inputField = self:FindGO("InputField", self.mainPage):GetComponent(UIInput)
    self.wishBtn = self:FindGO("WishBtn", self.mainPage)
    self.wishBtn_Icon = self:FindGO("Label", self.wishBtn):GetComponent(UISprite)
    self.wishBtn_BoxCollider = self.wishBtn:GetComponent(BoxCollider)
    self:AddClickEvent(self.wishBtn, function()
      MsgManager.ConfirmMsgByID(42116, function()
        local str = self.inputField.value
        ServiceActivityCmdProxy.Instance:CallWishActivityWishCmd(str)
        self:sendNotification(ServiceEvent.ActivityCmdWishActivityWishCmd)
      end, nil)
    end)
    local params = FunctionActivity.Me():GetParams(ActivityCmd_pb.GACTIVITY_WISH)
    local actid = params and params[1]
    if actid then
      local config = GameConfig.WishingTree and GameConfig.WishingTree[actid]
      local defaultStr = config and config.InputDefault
      if defaultStr then
        self.contentLabel.text = defaultStr
      end
    end
    local checkInput = function()
      local manualInput = self.inputField.value
      self:SetTextureGrey(self.wishBtn)
      self.wishBtn_BoxCollider.enabled = false
      if #manualInput == 0 then
        return
      end
      local inputLimit = GameConfig.WishingTree.InputMax or 100
      if inputLimit < #manualInput then
        local subInput = StringUtil.Sub(manualInput, 1, inputLimit)
        self.inputField.value = subInput
        MsgManager.ShowMsgByID(28010)
        return
      end
      if FunctionMaskWord.Me():CheckMaskWord(self.inputField.value, GameConfig.MaskWord.ChatroomName) then
        MsgManager.ShowMsgByIDTable(2604)
        return
      end
      self:SetTextureWhite(self.wishBtn, LuaGeometry.GetTempVector4(0.7686274509803922, 0.5254901960784314, 0, 1))
      self.wishBtn_BoxCollider.enabled = true
    end
    EventDelegate.Set(self.inputField.onSubmit, checkInput)
    self:AddSelectEvent(self.inputField, checkInput)
    checkInput()
  elseif type == 2 then
    self.mainPage = self:FindGO("PlayerWishPage")
    self.title = self:FindGO("Title", self.mainPage):GetComponent(UILabel)
    self.clickUrl = self.title.gameObject:GetComponent(UILabelClickUrl)
    self.contentScrollView = self:FindGO("ContentScrollView", self.mainPage):GetComponent(UIScrollView)
    self.contentLabel = self:FindGO("ContentLabel", self.mainPage):GetComponent(UILabel)
    self.likeBtn = self:FindGO("LikeBtn", self.mainPage)
    self.likeBtn_Icon = self:FindGO("LikeBtnIcon", self.likeBtn):GetComponent(UISprite)
    self.likeCount = self:FindGO("LikeCount", self.mainPage):GetComponent(UILabel)
    self:AddClickEvent(self.likeBtn, function()
      local id = self.id
      xdlog("申请点赞", id, self.liked)
      ServiceActivityCmdProxy.Instance:CallWishActivityLikeCmd(id, self.liked)
      self.liked = not self.liked
      self.likenum = self.likenum + (self.liked and 1 or -1)
      if self.charid == Game.Myself.data.id then
        self:sendNotification(BoliWishingEvent.LikeMyself, self.liked and 1 or -1)
      end
      self.likeCount.text = self.likenum
      self.likeBtn_Icon.spriteName = self.liked and "boliwishingcard_icon_01" or "boliwishingcard_icon_02"
      self.likeCount.color = self.liked and LuaGeometry.GetTempVector4(0.8901960784313725, 0.4, 0.4, 1) or LuaGeometry.GetTempVector4(0.43529411764705883, 0.43529411764705883, 0.43529411764705883, 1)
    end)
    
    function self.clickUrl.callback(url)
      if url ~= nil and self.charid ~= nil then
        xdlog("申请玩家数据", self.charid)
        self:sendNotification(UICellEvent.OnCellClicked)
        ServiceSessionSocialityProxy.Instance:CallQueryUserInfoCmd(self.charid)
      end
    end
  elseif type == 3 then
    self.mainPage = self:FindGO("MyselfDetailPage")
    self.infoScrollView = self:FindGO("InfoScrollView"):GetComponent(UIScrollView)
    self.infoTable = self:FindGO("Table", self.mainPage):GetComponent(UITable)
    self.contentLabel = self:FindGO("ContentLabel", self.mainPage):GetComponent(UILabel)
    self.wishingGrid = self:FindGO("WishingGrid"):GetComponent(UIGrid)
    self.wishingGridCtrl = UIGridListCtrl.new(self.wishingGrid, WishingPanelLikeCell, "WishingPanelLikeCell")
    self.nolikeTip = self:FindGO("NoLikeTip", self.mainPage):GetComponent(UIWidget)
    self.nolikeTipGO = self.nolikeTip.gameObject
    self.nolikeTipLabel = self:FindGO("NoLikeTipLabel", self.nolikeTipGO):GetComponent(UILabel)
    self.likeBtn = self:FindGO("LikeBtn", self.mainPage)
    self.likeBtn_Icon = self:FindGO("LikeBtnIcon", self.likeBtn):GetComponent(UISprite)
    self.likeCount = self:FindGO("LikeCount", self.mainPage):GetComponent(UILabel)
  end
end

function WishingCardCell:AddEvts()
end

function WishingCardCell:SetRecords(records)
  self.wishingGridCtrl:ResetDatas(records)
  self.infoTable:Reposition()
  self.nolikeTipGO:SetActive(#records == 0)
  self.likeCount.text = #records
end

function WishingCardCell:RemoveLikes()
  self.wishingGridCtrl:RemoveAll()
end

function WishingCardCell:playTween()
  local index = self.indexInList
  self.tweenPos.delay = (index + 1) * 0.2
  self.tweenPos.duration = 0.3
  self.tweenPos:ResetToBeginning()
  self.tweenPos:PlayForward()
  self.tweenAlpha.delay = (index + 1) * 0.2
  self.tweenAlpha.duration = 0.3
  self.tweenAlpha:ResetToBeginning()
  self.tweenAlpha:PlayForward()
end

function WishingCardCell:OnDestroy()
  PictureManager.Instance:UnLoadUI("boliwishingcard_bg", self.bgTexture)
  PictureManager.Instance:UnloadReturnActivityTexture("returnactivity_bg_coin_03", self.decorateCoin)
end
