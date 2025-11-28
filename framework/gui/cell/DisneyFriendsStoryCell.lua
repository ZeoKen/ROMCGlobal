local BaseCell = autoImport("BaseCell")
DisneyFriendsStoryCell = class("DisneyFriendsStoryCell", BaseCell)
local calSize = NGUIMath.CalculateRelativeWidgetBounds

function DisneyFriendsStoryCell:Init()
  DisneyFriendsStoryCell.super.Init(self)
  self:FindObjs()
  self:AddCellClickEvent()
end

function DisneyFriendsStoryCell:FindObjs()
  self.lock = self:FindGO("Lock")
  self.unlockPart = self:FindGO("UnlockPart")
  self.lockTweenRot = self.lock:GetComponent(TweenRotation)
  self.lockTweenColor = self.lock:GetComponent(TweenColor)
  self.storyLabel = self:FindGO("StoryLabel"):GetComponent(UILabel)
  self.lock:SetActive(false)
  self.statusIcon = self:FindGO("Status")
  self.bgSprite = self:FindGO("Bg"):GetComponent(UISprite)
  self.unlockPart = self:FindGO("UnlockPart")
  self.boxCollider = self.gameObject:GetComponent(BoxCollider)
  self.extendBtnGO = self:FindGO("ExtendBtn")
  self.extendLabel = self:FindGO("ExtendLabel")
  self.extendLabel:SetActive(false)
  self.extendBtn_UISprite = self.extendBtnGO:GetComponent(UISprite)
  self:SetEvent(self.extendBtnGO, function()
    self:PassEvent(DisneyEvent.DisneyFriendStoryCellExtendClick, self)
  end)
end

function DisneyFriendsStoryCell:SetData(data)
  self.data = data
  self.id = data.id
  self.extendStatus = false
  self.bgSprite.height = 26
  self.extendBtn_UISprite.height = 26
  self.storyLabel.overflowMethod = 3
  if data.lock then
    self.storyLabel.text = ""
    self.lock:SetActive(true)
    self.statusIcon:SetActive(false)
    self.lockTweenRot.enabled = false
    self.boxCollider.enabled = false
    self.unlockPart:SetActive(false)
    self.lockTweenColor.enabled = false
    self.lockTweenRot:ResetToBeginning()
    self.lock.transform.localRotation = LuaGeometry.Const_Qua_identity
    self.lockTweenColor:ResetToBeginning()
  else
    local storyConfig = Table_ManorPartnerStory[self.id]
    if not storyConfig then
      redlog("Table_ManorPartnerStory缺少", self.id)
      return
    end
    local menuId = storyConfig.FinishMenu
    if data.read then
      self.unlockPart:SetActive(true)
      local str = storyConfig.Desc
      local str = OverSea.LangManager.Instance():GetLangByKey(str)
      self.fullStr = str
      self.storyLabel.text = str
      local size = calSize(self.storyLabel.transform)
      local height = size.size.y
      self.column = math.round(height / 22)
      local len = string.len(str)
      if self.column > 1 then
        self.extendBtnGO:SetActive(true)
        self.storyLabel.text = storyConfig.Desc
        self.storyLabel.height = 22
        self.storyLabel.overflowMethod = 1
        self.extendLabel:SetActive(true)
      else
        self.extendBtnGO:SetActive(false)
        self.storyLabel.text = storyConfig.Desc
        self.storyLabel.overflowMethod = 3
        self.extendLabel:SetActive(false)
      end
      self.bgSprite.height = 26
      self.extendBtn_UISprite.height = 26
      if not menuId then
        self.statusIcon:SetActive(true)
        self.storyLabel.color = LuaGeometry.GetTempVector4(0.17647058823529413, 0.17254901960784313, 0.2784313725490196, 1)
      else
        local menuUnlock = FunctionUnLockFunc.Me():CheckCanOpen(menuId) or false
        self.statusIcon:SetActive(menuUnlock)
        self.storyLabel.color = menuUnlock and LuaGeometry.GetTempVector4(0.17647058823529413, 0.17254901960784313, 0.2784313725490196, 1) or LuaGeometry.GetTempVector4(0.5725490196078431, 0.596078431372549, 0.7333333333333333, 1)
      end
    else
      self.unlockPart:SetActive(false)
      self.statusIcon:SetActive(false)
    end
    self.lock:SetActive(not data.read)
    self.lockTweenRot:ResetToBeginning()
    self.lockTweenColor:ResetToBeginning()
    self.lockTweenRot.enabled = not data.read
    self.boxCollider.enabled = not data.read
    self.lockTweenColor.enabled = not data.read
  end
end

function DisneyFriendsStoryCell:SetExtendStatus()
  self.extendStatus = not self.extendStatus
  if not self.column then
    self.column = 1
  end
  local multi = self.extendStatus and self.column or 1
  self.bgSprite.height = 26 * multi
  self.extendBtn_UISprite.height = 26 * multi
  if self.extendStatus then
    self.storyLabel.text = self.fullStr
    self.storyLabel.overflowMethod = 3
    self.extendLabel:SetActive(false)
  else
    self.storyLabel.text = self.fullStr
    self.storyLabel.height = 22
    self.storyLabel.overflowMethod = 1
    self.extendLabel:SetActive(true)
  end
end
