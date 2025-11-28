autoImport("PersonalListPage")
autoImport("SceneryListPage")
autoImport("PostcardListPage")
PersonalPicturePanel = class("PersonalPicturePanel", ContainerView)
PersonalPicturePanel.GetPersonPicThumbnail = "PersonalPicturePanel_GetPersonPicThumbnail"
PersonalPicturePanel.ReplacePersonPicThumbnail = "PersonalPicturePanel_ReplacePersonPicThumbnail"
PersonalPicturePanel.ReUploadingPersonPicThumbnail = "PersonalPicturePanel_ReUploadingPersonPicThumbnail"
PersonalPicturePanel.DelPersonPicThumbnail = "PersonalPicturePanel_DelPersonPicThumbnail"
PersonalPicturePanel.CancelPersonPicThumbnail = "PersonalPicturePanel_CancelPersonPicThumbnail"
PersonalPicturePanel.ShowPictureDetail = "PersonalPicturePanel_ShowPictureDetail"
PersonalPicturePanel.Album = {
  PersonalAlbum = 1,
  SceneryAlbum = 2,
  PostcardAlbum = 3
}
PersonalPicturePanel.ViewType = UIViewType.Lv4PopUpLayer
PersonalPicturePanel.ShowMode = {
  ReplaceMode = 1,
  EditorMode = 2,
  NormalMode = 3,
  PickMode = 4
}

function PersonalPicturePanel:Init()
  self:initView()
  self:initData()
  local tab = self.initialTab or PersonalPicturePanel.Album.PersonalAlbum
  self:TabChangeHandler(tab)
end

function PersonalPicturePanel:OnEnter(...)
  PersonalPicturePanel.super.OnEnter(self)
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(false)
  self.bgTexture = self:FindComponent("bgTexture", UITexture)
  self.bgTexName = "bg_view_1"
  if self.bgTexture then
    PictureManager.Instance:SetUI(self.bgTexName, self.bgTexture)
    PictureManager.ReFitFullScreen(self.bgTexture, 1)
  end
  ServicePhotoCmdProxy.Instance:CallViewPostcardCmd()
end

function PersonalPicturePanel:OnExit()
  local manager_Camera = Game.GameObjectManagers[Game.GameObjectType.Camera]
  manager_Camera:ActiveMainCamera(true)
  if self.bgTexture then
    PictureManager.Instance:UnLoadUI(self.bgTexName, self.bgTexture)
  end
  PersonalPicturePanel.super.OnExit(self)
end

function PersonalPicturePanel:initData()
  ServicePhotoCmdProxy.Instance:CallQueryUserPhotoListPhotoCmd()
  if self.viewdata.viewdata then
    self.showMode = self.viewdata.viewdata.ShowMode
    self.callback = self.viewdata.viewdata.callback
    self.initialTab = self.viewdata.viewdata.initialTab or PersonalPicturePanel.Album.PersonalAlbum
  end
  self.showMode = self.showMode and self.showMode or PersonalPicturePanel.ShowMode.NormalMode
  if self.showMode == PersonalPicturePanel.ShowMode.ReplaceMode then
    if self.initialTab == PersonalPicturePanel.Album.PostcardAlbum then
      self:Hide(self:FindGO("PersonalTab"))
      self:Hide(self:FindGO("SceneryTab"))
      self.PostcardListPage = self:AddSubView("PostcardListPage", PostcardListPage)
    elseif self.initialTab == PersonalPicturePanel.Album.PersonalAlbum then
      self:Hide(self:FindGO("PostcardTab"))
      self:Hide(self:FindGO("SceneryTab"))
      self.PersonalListPage = self:AddSubView("PersonalListPage", PersonalListPage)
    elseif self.initialTab == PersonalPicturePanel.Album.SceneryAlbum then
      self:Hide(self:FindGO("PersonalTab"))
      self:Hide(self:FindGO("PostcardTab"))
      self.SceneryListPage = self:AddSubView("SceneryListPage", SceneryListPage)
    end
  else
    self.PostcardListPage = self:AddSubView("PostcardListPage", PostcardListPage)
    self.SceneryListPage = self:AddSubView("SceneryListPage", SceneryListPage)
    self.PersonalListPage = self:AddSubView("PersonalListPage", PersonalListPage)
  end
  self.Pick = self:FindGO("Pick")
  if self.showMode == PersonalPicturePanel.ShowMode.PickMode then
    self:Hide(self:FindGO("PostcardTab"))
    if self.initialTab == PersonalPicturePanel.Album.PostcardAlbum then
      self.initialTab = PersonalPicturePanel.Album.PersonalAlbum
    end
    self:Show(self.Pick)
    local pickBtn = self:FindGO("EditorMode", self.Pick)
    local pickText = self:FindComponent("EditorModeLabel", UILabel, pickBtn)
    local desText = self:FindComponent("Des", UILabel, self.Pick)
    pickText.text = ZhString.PersonalPictureCell_Pick
    desText.text = ZhString.PersonalPictureCell_PickDes
    self:AddClickEvent(pickBtn, function()
      local pickType, pickSource, pickId, pickCharId, pickTime, pickAccId
      if self.currentKey == PersonalPicturePanel.Album.PersonalAlbum and self.PersonalListPage.currentPickCell then
        pickType = PhotoDataProxy.PhotoType.PersonalPhotoType
        pickSource = self.PersonalListPage.currentPickCell.data.source
        pickId = self.PersonalListPage.currentPickCell.data.sourceid
        pickCharId = self.PersonalListPage.currentPickCell.data.charid
        pickTime = self.PersonalListPage.currentPickCell.data.time
      elseif self.currentKey == PersonalPicturePanel.Album.SceneryAlbum and self.SceneryListPage.currentPickCell then
        pickType = PhotoDataProxy.PhotoType.SceneryPhotoType
        pickSource = self.SceneryListPage.currentPickCell.data.source
        pickId = self.SceneryListPage.currentPickCell.data.sourceid
        pickTime = self.SceneryListPage.currentPickCell.data.time
        pickAccId = GamePhoto.playerAccount
        pickCharId = GamePhoto.playerAccount
      end
      if pickSource and pickId then
        if self.callback then
          self.callback({
            source = pickSource,
            sourceid = pickId,
            charid = pickCharId or 0,
            time = pickTime,
            accid = pickAccId or 0
          })
        end
        self:CloseSelf()
        redlog("pick source,sourceid", pickSource, pickId)
      end
    end)
  else
    self:Hide(self.Pick)
  end
end

function PersonalPicturePanel:initView()
  self:AddTabChangeEvent(self:FindGO("PersonalTab"), self:FindGO("PersonalListPage"), PersonalPicturePanel.Album.PersonalAlbum)
  self:AddTabChangeEvent(self:FindGO("SceneryTab"), self:FindGO("SceneryListPage"), PersonalPicturePanel.Album.SceneryAlbum)
  self:AddTabChangeEvent(self:FindGO("PostcardTab"), self:FindGO("PostcardListPage"), PersonalPicturePanel.Album.PostcardAlbum)
  self.PersonalTabLabel = self:FindComponent("PersonalTabLabel", UILabel)
  self.SceneryTabLabel = self:FindComponent("SceneryTabLabel", UILabel)
  self.PostcardTabLabel = self:FindComponent("PostcardTabLabel", UILabel)
end

local tempColor = LuaColor(0.14901960784313725, 0.2823529411764706, 0.5803921568627451)

function PersonalPicturePanel:handleCategoryClick(key)
  self:handleCategorySelect(key)
  if key == PersonalPicturePanel.Album.PersonalAlbum then
    self.PersonalTabLabel.effectStyle = UILabel.Effect.Outline8
    self.PersonalTabLabel.effectColor = tempColor
    self.SceneryTabLabel.effectStyle = UILabel.Effect.None
    if self.PostcardTabLabel then
      self.PostcardTabLabel.effectStyle = UILabel.Effect.None
    end
  elseif key == PersonalPicturePanel.Album.SceneryAlbum then
    self.PersonalTabLabel.effectStyle = UILabel.Effect.None
    self.SceneryTabLabel.effectColor = tempColor
    self.SceneryTabLabel.effectStyle = UILabel.Effect.Outline8
    if self.PostcardTabLabel then
      self.PostcardTabLabel.effectStyle = UILabel.Effect.None
    end
  elseif key == PersonalPicturePanel.Album.PostcardAlbum then
    self.PersonalTabLabel.effectStyle = UILabel.Effect.None
    self.SceneryTabLabel.effectStyle = UILabel.Effect.None
    if self.PostcardTabLabel then
      self.PostcardTabLabel.effectColor = tempColor
      self.PostcardTabLabel.effectStyle = UILabel.Effect.Outline8
    end
  end
end

function PersonalPicturePanel:handleCategorySelect(key)
  if key == PersonalPicturePanel.Album.PersonalAlbum then
  elseif key == PersonalPicturePanel.Album.SceneryAlbum then
    if self.SceneryListPage then
      self.SceneryListPage:ResetPosition()
    end
  elseif key == PersonalPicturePanel.Album.PostcardAlbum and self.PostcardListPage then
    self.PostcardListPage:ResetPosition()
  end
  if self.showMode == PersonalPicturePanel.ShowMode.PickMode then
    self.PersonalListPage:ClearCurrentPickCell()
    self.SceneryListPage:ClearCurrentPickCell()
  end
end

function PersonalPicturePanel:TabChangeHandler(key)
  if self.currentKey ~= key then
    PersonalPicturePanel.super.TabChangeHandler(self, key)
    self:handleCategoryClick(key)
    self.currentKey = key
  end
end

function PersonalPicturePanel:ManualRefreshPhotos()
  LogUtility.Info(string.format("[%s] ManualRefreshPhotos()", self.__cname))
  local outCacheIndexs = ReusableTable.CreateArray()
  PersonalPictureManager.Instance():RemoveAllThumbnailTextures(outCacheIndexs)
  FunctionPhotoStorage.Me():RemoveAllPersonalLocalCacheFiles(outCacheIndexs)
  ReusableTable.DestroyAndClearArray(outCacheIndexs)
  outCacheIndexs = ReusableTable.CreateArray()
  MySceneryPictureManager.Instance():RemoveAllThumbnailTextures(outCacheIndexs)
  FunctionPhotoStorage.Me():RemoveAllSceneryLocalCacheFiles(outCacheIndexs)
  ReusableTable.DestroyAndClearArray(outCacheIndexs)
  if self.currentKey == 1 then
    self.PersonalListPage:UpdateList()
  else
    self.SceneryListPage:UpdateList()
  end
end
