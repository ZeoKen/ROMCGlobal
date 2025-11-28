autoImport("BaseView")
SgGuideView = class("SgGuideView", BaseView)
SgGuideView.ViewType = UIViewType.NormalLayer

function SgGuideView:Init()
  self.m_uiImgPages = {}
  for i = 1, 13 do
    local ui = self:FindGO("uiImgBg/uiImgTab/uImgPage" .. i .. "/uiImgSelected"):GetComponent(UISprite)
    table.insert(self.m_uiImgPages, ui)
  end
  self.m_uiTxtTitle = self:FindGO("uiImgBg/uiTxtTitle"):GetComponent(UILabel)
  self.m_uiTxtTips = self:FindGO("uiImgBg/uiTxtTips"):GetComponent(UILabel)
  self.m_uiTexPics = {}
  for i = 1, 13 do
    local ui = self:FindGO("uiImgBg/uiImgCenter2/uiTexPic" .. i):GetComponent(UITexture)
    table.insert(self.m_uiTexPics, ui)
  end
  self.m_uiImgTab = self:FindGO("uiImgBg/uiImgTab"):GetComponent(UISprite)
  self.m_uiImgBtnMask = self:FindGO("uiImgMask")
  self.m_uiImgBtnLeft = self:FindGO("uiImgBg/uiBtnLeft")
  self.m_uiImgBtnRight = self:FindGO("uiImgBg/uiBtnRight")
  self.m_uiImgBtnClose = self:FindGO("uiImgBg/uiBtnClose")
  self:AddClickEvent(self.m_uiImgBtnMask, function()
    self:onClickBtnMask()
  end)
  self:AddClickEvent(self.m_uiImgBtnLeft, function()
    self:onClickBtnLeft()
  end)
  self:AddClickEvent(self.m_uiImgBtnRight, function()
    self:onClickBtnRight()
  end)
  self:AddClickEvent(self.m_uiImgBtnClose, function()
    self:CloseSelf()
  end)
  self.m_selectIndex = 1
  self.m_data = {}
  local addData = function(_id)
    if _id == nil then
      return
    end
    for _, v in pairs(Table_NewGuideUI) do
      if v.Group == _id then
        table.insert(self.m_data, v)
      end
    end
  end
  local viewdata = self.viewdata.viewdata
  local params = viewdata and viewdata.params
  if params and params.group_id then
    if type(params.group_id) == "table" then
      for i = 1, #params.group_id do
        addData(params.group_id[i])
      end
    else
      addData(params.group_id)
    end
  else
    addData(self.viewdata.viewdata.groupId)
    addData(self.viewdata.viewdata.groupId1)
    addData(self.viewdata.viewdata.groupId2)
    addData(self.viewdata.viewdata.groupId3)
    addData(self.viewdata.viewdata.groupId4)
    addData(self.viewdata.viewdata.groupId5)
    addData(self.viewdata.viewdata.groupId6)
    addData(self.viewdata.viewdata.groupId7)
    addData(self.viewdata.viewdata.groupId8)
    addData(self.viewdata.viewdata.groupId9)
  end
  if 1 > #self.m_data then
    redlog("心锁引导->缺少配置")
    return
  end
  self.m_maxPage = #self.m_data
  for i, v in ipairs(self.m_data) do
    PictureManager.Instance:SetSevenRoyalFamiliesTexture(v.Pic, self.m_uiTexPics[i])
  end
  for i, v in ipairs(self.m_uiImgPages) do
    v.transform.parent.gameObject:SetActive(i <= self.m_maxPage)
  end
  self.m_uiImgTab.width = 26 + self.m_maxPage * 26
  if self.m_maxPage % 2 == 0 then
    local x = 0 - self.m_maxPage / 2 * 26 + 13
    for i = 1, self.m_maxPage do
      self.m_uiImgPages[i].transform.parent.localPosition = LuaGeometry.GetTempVector3(x + (i - 1) * 26, 0, 1)
    end
  else
    local x = 0 - (self.m_maxPage - 1) / 2 * 26
    for i = 1, self.m_maxPage do
      self.m_uiImgPages[i].transform.parent.localPosition = LuaGeometry.GetTempVector3(x + (i - 1) * 26, 0, 1)
    end
  end
  if 1 < self.m_maxPage then
    self.m_uiImgBtnClose.gameObject:SetActive(false)
  elseif self.m_uiEffect == nil then
    self.m_uiEffect = Asset_Effect.PlayOn(EffectMap.Maps.SgGuideCloseEffect, self.m_uiImgBtnClose.transform)
  end
  self:onChangePage()
end

function SgGuideView:onClickBtnMask()
end

function SgGuideView:onClickBtnLeft()
  self.m_selectIndex = self.m_selectIndex - 1
  if self.m_selectIndex < 1 then
    self.m_selectIndex = 1
  end
  self:onChangePage()
end

function SgGuideView:onClickBtnRight()
  self.m_selectIndex = self.m_selectIndex + 1
  if self.m_selectIndex >= self.m_maxPage then
    self.m_selectIndex = self.m_maxPage
    self.m_uiImgBtnClose.gameObject:SetActive(true)
    if self.m_uiEffect == nil then
      self.m_uiEffect = Asset_Effect.PlayOn(EffectMap.Maps.SgGuideCloseEffect, self.m_uiImgBtnClose.transform)
    end
  end
  self:onChangePage()
end

function SgGuideView:onChangePage()
  for i, v in ipairs(self.m_uiImgPages) do
    v.gameObject:SetActive(i == self.m_selectIndex)
  end
  for i, v in ipairs(self.m_uiTexPics) do
    v.gameObject:SetActive(i == self.m_selectIndex)
  end
  self.m_uiTxtTitle.text = self.m_data[self.m_selectIndex].Title
  self.m_uiTxtTips.text = self.m_data[self.m_selectIndex].Desc
end

function SgGuideView:CloseSelf()
  for i, v in ipairs(self.m_data) do
    PictureManager.Instance:UnloadSevenRoyalFamiliesTexture(v.Pic, self.m_uiTexPics[i])
  end
  if self.m_uiEffect ~= nil then
    ReusableObject.Destroy(self.m_uiEffect)
    self.m_uiEffect = nil
  end
  SgGuideView.super.CloseSelf(self)
end
