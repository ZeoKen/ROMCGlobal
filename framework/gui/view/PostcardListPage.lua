PostcardListPage = class("PostcardListPage", SubView)
autoImport("WrapCellHelper")
autoImport("PersonalPictureCell")
autoImport("PostcardListCombineItemCell")
autoImport("PostcardView")
PostcardListPage.ClickId = {RefreshIndicator = 1, CheckSelect = 2}

function PostcardListPage:Init()
  self:AddViewEvts()
  self:initView()
  self:initData()
end

function PostcardListPage:AddViewEvts()
  self:AddListenEvt(ServiceEvent.PhotoCmdPostcardListCmd, self.PhotoCmdPhotoUpdateNtf)
  self:AddListenEvt(ServiceEvent.PhotoCmdUpdatePostcardCmd, self.PhotoCmdPhotoUpdateNtf)
  self:AddListenEvt(FunctionPostcardTex.DlEvent.PhotoDonwloadSucc, self.PersonalThumbnailPhDlCpCallback)
  self:AddListenEvt(FunctionPostcardTex.DlEvent.PhotoDonwloadFailed, self.PersonalThumbnailPhDlErCallback)
  self:AddListenEvt(FunctionPostcardTex.DlEvent.PhotoDonwloadTerminated, self.PersonalThumbnailPhDlErCallback)
end

function PostcardListPage:PersonalThumbnailPhDlPgCallback(note)
  local data = note.body
  if not data.is_thumb then
    return
  end
  local cell = self:GetItemCellById(data.id)
  if cell then
    cell:setDownloadProgress(data.progress or 0)
  end
end

function PostcardListPage:PersonalThumbnailPhDlCpCallback(note)
  local data = note.body
  if not data.is_thumb then
    return
  end
  local cell = self:GetItemCellById(data.id)
  if cell then
    self:GetPersonPicThumbnail(cell)
  end
end

function PostcardListPage:PersonalThumbnailPhDlErCallback(note)
  local data = note.body
  if not data.is_thumb then
    return
  end
  local cell = self:GetItemCellById(data.id)
  if cell then
    cell:setDownloadFailure()
  end
end

function PostcardListPage:DelPersonPicThumbnail(cellCtl)
  FunctionCloudFile.Me():log("DelPersonPicThumbnail")
  if cellCtl and cellCtl.data then
    MsgManager.ConfirmMsgByID(43369, function()
      PostcardTestMe.Me():CallDelPostcardCmd(cellCtl.data.id)
    end, nil)
  end
end

function PostcardListPage:ReplacePersonPicThumbnail(cellCtl)
  if cellCtl and cellCtl.data then
    MsgManager.ConfirmMsgByID(992, function()
      if self.callback then
        self.callback(cellCtl.data.id)
      end
      self.container:CloseSelf()
    end, nil)
  end
end

function PostcardListPage:PhotoCmdPhotoUpdateNtf(note)
  self:UpdateList(true)
end

function PostcardListPage:initView()
  self.gameObject = self:FindGO("PostcardListPage")
  local itemContainer = self:FindGO("bag_itemContainer")
  local pfbNum = 7
  local wrapConfig = {
    wrapObj = itemContainer,
    pfbNum = pfbNum,
    cellName = "PersonalPicturCombineItemCell",
    control = PostcardListCombineItemCell,
    dir = 2
  }
  self.wraplist = WrapCellHelper.new(wrapConfig)
  self.wraplist:AddEventListener(MouseEvent.MouseClick, self.HandleClickItem, self)
  self.wraplist:AddEventListener(PersonalPicturePanel.GetPersonPicThumbnail, self.GetPersonPicThumbnail, self)
  self.wraplist:AddEventListener(PersonalPicturePanel.ReplacePersonPicThumbnail, self.ReplacePersonPicThumbnail, self)
  self.wraplist:AddEventListener(PersonalPicturePanel.DelPersonPicThumbnail, self.DelPersonPicThumbnail, self)
  self.wraplist:AddEventListener(PersonalPicturePanel.ShowPictureDetail, self.ShowPictureDetail, self)
  self.scrollView = self:FindComponent("ItemScrollView", ROUIScrollView)
  
  function self.scrollView.OnStop()
    self:ScrollViewRevert()
  end
  
  self.emptyCt = self:FindGO("emptyCt")
  local emptyDes = self:FindComponent("emptyDes", UILabel)
  local emptySp = self:FindComponent("emptySp", UISprite)
  emptySp:UpdateAnchors()
  self.albumState = self:FindComponent("albumState", UILabel)
  self.albumState.text = ZhString.PersonalPicturePanel_AlbumStateFull
  self.curState = self:FindComponent("CurState", UILabel)
  self.EditorModeLabel = self:FindComponent("EditorModeLabel", UILabel)
  self.EditorMode = self:FindGO("EditorMode")
  self:AddClickEvent(self.EditorMode, function()
    if self.showMode == PersonalPicturePanel.ShowMode.NormalMode then
      self.showMode = PersonalPicturePanel.ShowMode.EditorMode
    else
      self.showMode = PersonalPicturePanel.ShowMode.NormalMode
    end
    self:RefreshUIByMode()
  end)
  self.leftIndicator = self:FindGO("leftIndicator")
  self.rightIndicator = self:FindGO("rightIndicator")
  local helpBtn = self:FindGO("HelpBtn")
  self:TryOpenHelpViewById(35278, nil, helpBtn)
end

function PostcardListPage:RefreshUIByMode()
  if self.showMode == PersonalPicturePanel.ShowMode.ReplaceMode then
    self:Show(self.albumState.gameObject)
    self:Hide(self.EditorMode)
    self.albumState:UpdateAnchors()
  elseif self.showMode == PersonalPicturePanel.ShowMode.EditorMode then
    self.EditorModeLabel.text = ZhString.PersonalPicturePanel_ShowModeEditor_1
    self:Show(self.EditorMode)
  elseif self.showMode == PersonalPicturePanel.ShowMode.PickMode then
    self:Hide(self.EditorMode)
    self:Hide(self.albumState.gameObject)
  else
    self:Show(self.EditorMode)
    self.EditorModeLabel.text = ZhString.PersonalPicturePanel_ShowModeEditor
    self:Hide(self.albumState.gameObject)
  end
  local cells = self:GetItemCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local single = cells[i]
      single:setMode(self.showMode)
    end
  end
end

function PostcardListPage:initData()
  self.showMode = self.container.showMode
  self.showMode = self.showMode and self.showMode or PersonalPicturePanel.ShowMode.NormalMode
  self.callback = self.container.callback
  self:UpdateList()
  TimeTickManager.Me():CreateTick(1000, 500, self.refreshLRIndicator, self, PostcardListPage.ClickId.RefreshIndicator)
  if not FunctionPhotoStorage.IsActive() then
    local datas = PostcardProxy.Instance:Query_GetAllPostcards()
    PersonalPictureManager.Instance():AddMyThumbnailInfos(datas)
  end
end

function PostcardListPage:refreshLRIndicator()
  local b = self.scrollView.bounds
  if self.scrollView.panel then
    local clip = self.scrollView.panel.finalClipRegion
    local hx = clip.z * 0.5
    local hy = clip.w * 0.5
    if b.min.x < clip.x - hx then
      self:Show(self.leftIndicator)
    else
      self:Hide(self.leftIndicator)
    end
    if b.max.x > clip.x + hx then
      self:Show(self.rightIndicator)
    else
      self:Hide(self.rightIndicator)
    end
  end
end

function PostcardListPage:tabClick(noResetPos)
  self:UpdateList(noResetPos)
end

function PostcardListPage:OnEnter()
end

function PostcardListPage:OnExit()
  TimeTickManager.Me():ClearTick(self)
  self.wraplist:Destroy()
end

function PostcardListPage:UpdateList(noResetPos)
  local datas = PostcardProxy.Instance:Query_GetAllPostcards()
  if not datas or #datas == 0 then
    self:Show(self.emptyCt)
  else
    self:Hide(self.emptyCt)
  end
  local total = GameConfig.Postcard.CardSaveLimit
  local cur = PostcardProxy.Instance:Query_GetSaveCount()
  if total < cur then
    self.curState.text = "[c][FF1212FF]" .. cur .. "/" .. total .. "[-][/c]"
  else
    self.curState.text = "[c][ADADADFF]" .. cur .. "/" .. total .. "[-][/c]"
  end
  self:SetData(datas, noResetPos)
  self:RefreshUIByMode()
end

function PostcardListPage:SetData(datas, noResetPos)
  local newdata = self:ReUnitData(datas, 4)
  self.wraplist:UpdateInfo(newdata)
  if not noResetPos then
    self.wraplist:ResetPosition()
  end
end

function PostcardListPage:ReUnitData(datas, rowNum)
  if not self.unitData then
    self.unitData = {}
  else
    TableUtility.ArrayClear(self.unitData)
  end
  if datas ~= nil and 0 < #datas then
    for i = 1, #datas do
      local i1 = math.floor((i - 1) / rowNum) + 1
      local i2 = math.floor((i - 1) % rowNum) + 1
      self.unitData[i1] = self.unitData[i1] or {}
      self.unitData[i1][i2] = datas[i]
    end
  end
  return self.unitData
end

function PostcardListPage:ResetPosition()
  if not self.hasReset then
    self.hasReset = true
    if self.wraplist then
      self.wraplist:ResetPosition()
    end
  end
end

function PostcardListPage:GetPersonPicThumbnail(cellCtl)
  if cellCtl and cellCtl.data then
    local tex = cellCtl.data:Tex_TryLoadOutOrDl(true)
    if tex then
      cellCtl:setTexture(tex)
    end
  end
end

function PostcardListPage:HandleClickItem(cellCtl)
  if cellCtl and cellCtl.data then
    FunctionCloudFile.Me():log("HandleClickItem")
    if self.showMode == PersonalPicturePanel.ShowMode.PickMode then
      if self.currentPickCell ~= cellCtl then
        if self.currentPickCell then
          self.currentPickCell:setIsPick(false)
        end
        self.currentPickCell = cellCtl
        self.currentPickCell:setIsPick(true)
      else
        self.currentPickCell:setIsPick(false)
        self.currentPickCell = nil
      end
    elseif self.showMode ~= PersonalPicturePanel.ShowMode.ReplaceMode then
      self:ShowPictureDetail(cellCtl)
    end
  end
end

function PostcardListPage:ClearCurrentPickCell()
  if self.currentPickCell then
    self.currentPickCell:setIsPick(false)
    self.currentPickCell = nil
  end
end

function PostcardListPage:ShowPictureDetail(cellCtl)
  if cellCtl and cellCtl.data and cellCtl.status == PersonalPictureCell.PhotoStatus.Success then
    local viewdata = {
      postcard = cellCtl.data,
      usageType = 3
    }
    if self.showMode == PersonalPicturePanel.ShowMode.PickMode then
      viewdata.readOnly = true
    end
    PostcardView.ViewType = UIViewType.PopUpLayer
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PostcardView,
      viewdata = viewdata
    })
  end
end

function PostcardListPage:GetItemCellById(id)
  local cells = self:GetItemCells()
  if cells and 0 < #cells then
    for i = 1, #cells do
      local single = cells[i]
      if single.data and single.data.id == id then
        return single
      end
    end
  end
end

function PostcardListPage:GetItemCells()
  local combineCells = self.wraplist:GetCellCtls()
  local result = {}
  for i = 1, #combineCells do
    local v = combineCells[i]
    local childs = v:GetCells()
    for i = 1, #childs do
      table.insert(result, childs[i])
    end
  end
  return result
end
