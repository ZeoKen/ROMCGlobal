NewContentPushCell = class("NewContentPushCell", BaseCell)

function NewContentPushCell:Init()
  self.titleLabel = self:FindGO("title"):GetComponent(UILabel)
  self.contentLabel = self:FindGO("content"):GetComponent(UILabel)
  self.levelGo = self:FindGO("level")
  self.levelTitle = self:FindGO("levelLabel")
  self.locationGo = self:FindGO("location")
  self.locationTitle = self:FindGO("locationLabel")
  self:AddButtonEvent("goBtn", function()
    if self.requireLevel then
      local myLevel = MyselfProxy.Instance:RoleLevel()
      if #self.requireLevel > 1 then
        local minLevel = tonumber(self.requireLevel[1])
        local maxLevel = tonumber(self.requireLevel[2])
        if myLevel < minLevel or myLevel > maxLevel then
          MsgManager.ShowMsgByID(28090)
          return
        end
      elseif #self.requireLevel > 0 then
        local minLevel = tonumber(self.requireLevel[1])
        if myLevel < minLevel then
          MsgManager.ShowMsgByID(28090)
          return
        end
      end
    end
    if self.menuId and not FunctionUnLockFunc.Me():CheckCanOpen(self.menuId, true) then
      self:Notify(NewContentPushEvent.Close)
      return
    end
    if self.questId then
      local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(self.questId)
      if questData then
        FunctionQuest.Me():executeManualQuest(questData)
        self:Notify(NewContentPushEvent.Close)
        return
      end
    end
    if self.shortId then
      local data = {}
      data.shortId = self.shortId
      data.param = self.param
      data.failJump = self.failJump
      data.failJumpParam = self.failJumpParam
      self:Notify(NewContentPushEvent.Close, data)
    end
  end)
  self.banner = self:FindGO("banner"):GetComponent(UITexture)
end

function NewContentPushCell:SetData(data)
  self.titleLabel.text = data.title
  self.contentLabel.text = data.description
  if self.levelGo then
    local levelLabel = self.levelGo:GetComponent(UILabel)
    local levelTitleLabel = self.levelTitle:GetComponent(UILabel)
    if not StringUtil.IsEmpty(data.level) then
      self.requireLevel = string.split(data.level, ";")
      if #self.requireLevel > 1 then
        levelLabel.text = "Lv." .. self.requireLevel[1] .. "~Lv." .. self.requireLevel[2]
      elseif #self.requireLevel > 0 then
        levelLabel.text = "Lv." .. self.requireLevel[1]
      end
      levelTitleLabel.alpha = 1
    else
      levelLabel.text = ""
      levelTitleLabel.alpha = 0
    end
  end
  if self.locationGo then
    local locationLabel = self.locationGo:GetComponent(UILabel)
    local locationTitleLabel = self.locationTitle:GetComponent(UILabel)
    if not StringUtil.IsEmpty(data.location) then
      locationLabel.text = data.location
      locationTitleLabel.alpha = 1
    else
      locationLabel.text = ""
      locationTitleLabel.alpha = 0
    end
  end
  if not StringUtil.IsEmpty(data.texture) then
    self.bannerName = data.texture
    PictureManager.Instance:SetPushTexture(data.texture, self.banner)
  else
    redlog("texture is nil!!!")
  end
  self.shortId = data.shortId
  self.param = data.param
  self.failJump = data.failJump
  self.failJumpParam = data.failJumpParam
  self.questId = data.questID
  self.menuId = data.menuId
end

function NewContentPushCell:OnDestroy()
  if self.bannerName then
    PictureManager.Instance:UnloadPushTexture(self.bannerName, self.banner)
  end
end
