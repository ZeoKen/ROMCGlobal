autoImport("HeadIconCell")
local baseCell = autoImport("BaseCell")
local tempVector3 = LuaVector3.Zero()
ChatRoomCell = reusableClass("ChatRoomCell", baseCell)
ChatRoomCell.PoolSize = 60
local localData = {}
local pos = LuaVector3.Zero()

function ChatRoomCell:Construct(asArray, args)
  self._alive = true
  self:DoConstruct(asArray, args)
end

function ChatRoomCell:Deconstruct()
  self._alive = false
  self.data = nil
  self.voiceid = nil
  self.voicetime = nil
  self.photoTex.mainTexture = nil
  self.isPhotoCp = nil
  self:UnloadEmoji()
  Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function ChatRoomCell:Alive()
  return self._alive
end

function ChatRoomCell:DoConstruct(asArray, args)
  self.parent = args
  if self.gameObject == nil then
    self:CreateSelf(self.parent)
    self:FindObjs()
    self:AddEvts()
    self:InitShow()
  else
    self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject, self.parent)
  end
end

function ChatRoomCell:Finalize()
  ChatRoomCell.super.ClearEvent(self)
  EventManager.Me():RemoveEventListener(HomeWallPicManager.WallPicThumbnailDownloadProgressCallback, self.ChatPhotoThumbnailPhDlPgCallback, self)
  EventManager.Me():RemoveEventListener(HomeWallPicManager.WallPicThumbnailDownloadCompleteCallback, self.ChatPhotoThumbnailPhDlCpCallback, self)
  EventManager.Me():RemoveEventListener(HomeWallPicManager.WallPicThumbnailDownloadErrorCallback, self.ChatPhotoThumbnailPhDlErCallback, self)
  self:ClearCB()
  GameObject.Destroy(self.gameObject)
end

function ChatRoomCell:ClearEvent()
end

function ChatRoomCell:CreateSelf(parent)
end

function ChatRoomCell:FindObjs()
  local headContainer = self:FindGO("HeadContainer")
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(headContainer)
  self.headIcon.gameObject:AddComponent(UIDragScrollView)
  self.headIcon:SetScale(0.68)
  self.headIcon:SetMinDepth(2)
  self.chatContent = self:FindGO("chatContent"):GetComponent(UILabel)
  self.clickUrl = self.chatContent.gameObject:GetComponent(UILabelClickUrl)
  self.contentSprite = self:FindGO("contentSpriteBg")
  self.contentSpriteBg = self.contentSprite:GetComponent(UITexture)
  self.speechBg = self:FindGO("speechBg")
  self.speechTime = self:FindGO("speechTime"):GetComponent(UILabel)
  self.voiceTween = self:FindGO("voice"):GetComponent(TweenColor)
  self.nameTrans = self:FindGO("name")
  self.name = self.nameTrans:GetComponent(UILabel)
  self.nameTrans = self.nameTrans.transform
  self.adventureTrans = self:FindGO("adventure")
  self.adventure = self.adventureTrans:GetComponent(UILabel)
  self.adventureTrans = self.adventureTrans.transform
  self.returnSymbol = self:FindGO("returnSymbol")
  self.photoTrans = self:FindGO("photo")
  self.photoLoad = self:FindGO("loadBg", self.photoTrans)
  self.photoLoadInfo = self:FindComponent("info", UILabel, self.photoLoad)
  self.photoLoadBar = self:FindComponent("progress", UISlider, self.photoLoad)
  self.photoTex = self:FindComponent("texture", UITextureEx, self.photoTrans)
  self.photoShow = self:FindGO("show", self.photoTrans)
  self:AddClickEvent(self.photoShow, function()
    if self.data then
      self.data:GetPhoto(true)
      self.data:SetPhotoLoaded(true)
      self:LoadPhoto()
    end
  end)
  self.selfName = self:FindGO("name"):GetComponent(UILabel)
  self.adventure = self:FindGO("adventure"):GetComponent(UILabel)
  self.currentChannel = self:FindGO("currentChannel"):GetComponent(UILabel)
  self.contentPos = LuaVector3.zero
  self.top = self:FindGO("Top"):GetComponent(UIWidget)
  self.Voice = self:FindGO("Voice")
  self.emojiRoot = self:FindGO("EmojiRoot")
  self:AddClickEvent(self.emojiRoot, function()
    self:UpdateTipoff()
  end)
  for i = 1, 4 do
    self["bgDecorate" .. i] = self:FindGO("bgDecorate" .. i)
    if self["bgDecorate" .. i] then
      self["bgDecorate" .. i .. "_Icon"] = self["bgDecorate" .. i]:GetComponent(UITexture)
    end
  end
  self:InitTipoff()
end

function ChatRoomCell:AddEvts()
  self:SetEvent(self.headIcon.clickObj.gameObject, function()
    self:PassEvent(ChatRoomEvent.SelectHead, self)
  end)
  
  function self.clickUrl.callback(url)
    if self:TryReceivePostcard() then
      return
    end
    local split = string.split(url, ChatRoomProxy.ItemCodeSymbol)
    local splitLength = #split
    if splitLength == 2 then
      if split[1] == "treasure" then
        ServiceGuildCmdProxy.Instance:CallQueryTreasureResultGuildCmd(tonumber(split[2]))
      elseif split[1] == "shareitem" then
        self.tipoffForbidden = true
        self:onShareItemClick(tonumber(split[2]))
      else
        ServiceChatCmdProxy.Instance:CallQueryItemData(split[1])
      end
    elseif splitLength == 1 then
      local num_split1 = tonumber(split[1])
      if nil ~= num_split1 and Table_TeamGoals[num_split1] then
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.TeamFindPopUp,
          viewdata = {goalid = num_split1}
        })
      elseif self.data ~= nil then
        local temp = ReusableTable.CreateTable()
        temp.data = self.data
        temp.url = url
        TipManager.Instance:ShowTutorFindTip(temp, self.headIcon.clickObj, NGUIUtil.AnchorSide.Right, {260, -200})
        ReusableTable.DestroyAndClearTable(temp)
      end
    elseif splitLength == 4 and split[1] == "lovechallenge" then
      if split[2] == 1 or tonumber(split[2]) == 1 then
        local guid = split[3]
        local endTime = MiniGameProxy.Instance:GetInviteEndStamp(guid)
        if not endTime or endTime < ServerTime.CurServerTime() / 1000 then
          MsgManager.ShowMsgByID(43318)
          return
        end
        local inviterName = split[4]
        GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
          view = PanelConfig.LoveChallengeView,
          viewdata = {
            page = 1,
            inviterID = guid,
            inviterName = inviterName
          }
        })
      elseif split[2] == 2 or tonumber(split[2]) == 2 then
        local braveName = split[4]
        local blessMsg = GameConfig.LoveChallenge and GameConfig.LoveChallenge.BlessMsg
        if not blessMsg then
          return
        end
        local formatStr = blessMsg[math.random(#blessMsg)]
        local str = ""
        if string.find(formatStr, "%%s") then
          str = string.format(blessMsg[math.random(#blessMsg)], braveName)
        else
          str = formatStr
        end
        local data = {
          type = "lovechallenge",
          loveconfession = 3,
          str = str
        }
        GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendSysmsgEvent, data)
        local keyEffect = Table_KeywordAnimation[10]
        GameFacade.Instance:sendNotification(ChatRoomEvent.AutoSendKeywordEffect, keyEffect)
      end
    end
  end
  
  self:AddClickEvent(self.speechBg, function(g)
    self:PlaySpeech()
  end)
  self:AddClickEvent(self.photoTex.gameObject, function(g)
    self:ShowChatPhotoDetail()
  end)
  EventManager.Me():AddEventListener(HomeWallPicManager.WallPicThumbnailDownloadProgressCallback, self.ChatPhotoThumbnailPhDlPgCallback, self)
  EventManager.Me():AddEventListener(HomeWallPicManager.WallPicThumbnailDownloadCompleteCallback, self.ChatPhotoThumbnailPhDlCpCallback, self)
  EventManager.Me():AddEventListener(HomeWallPicManager.WallPicThumbnailDownloadErrorCallback, self.ChatPhotoThumbnailPhDlErCallback, self)
end

function ChatRoomCell:InitShow()
  LuaVector3.Better_Set(pos, LuaGameObject.GetLocalPosition(self.gameObject.transform))
  LuaVector3.Better_Set(self.contentPos, LuaGameObject.GetLocalPosition(self.chatContent.transform))
  self.contentPos[2] = -16
  self.contentPos[3] = 0
  self.contentWidth = 260
  self.voiceTween.enabled = false
  self.chatContent.width = self.contentWidth
  self.chatContent.overflowMethod = 3
  self.chatContent.skipTranslation = true
end

function ChatRoomCell:TipoffValid()
  if not self.data then
    return false
  end
  if FunctionTipoff.IsForbidden() then
    return false
  end
  if self.tipoffForbidden then
    return false
  end
  if self.data:GetChannel() ~= ChatChannelEnum.World then
    return false
  end
  if self.data:GetId() == Game.Myself.data.id or self.data.roleType == ChatRoleEnum.Pet or self.data.roleType == ChatRoleEnum.Npc then
    return false
  end
  return true
end

function ChatRoomCell:InitTipoff()
  self.chatContentColider = self.chatContent.gameObject:GetComponent(BoxCollider)
  self.tipoffBtn = self:FindGO("TipoffBtn")
  if not self.tipoffBtn then
    return
  end
  local tipoffHide = function()
    self.tipoffActive = false
  end
  self.tipoffCloseComp = self.tipoffBtn:GetComponent(CloseWhenClickOtherPlace)
  self.tipoffCloseComp.callBack = tipoffHide
  self.tipoffLab = self:FindComponent("Label", UILabel, self.tipoffBtn)
  self.tipoffLab.text = ZhString.FunctionPlayerTip_Tipoff
  self:AddClickEvent(self.chatContentColider.gameObject, function()
    self:UpdateTipoff()
  end)
  self:AddClickEvent(self.tipoffBtn, function()
    self:OnClickTipoff()
  end)
end

function ChatRoomCell:ClearCB()
  if self.tipoffCloseComp then
    self.tipoffCloseComp.callBack = nil
  end
  self.tipoffActive = nil
end

function ChatRoomCell:OnClickTipoff()
  if not self:TipoffValid() then
    return
  end
  local ptdata = PlayerTipData.new()
  ptdata:SetByChatMessageData(self.data)
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.TipoffView,
    viewdata = {data = ptdata}
  })
end

function ChatRoomCell:UpdateTipoff()
  if not self:TipoffValid() then
    return
  end
  if not self.tipoffActive then
    self.tipoffBtn:SetActive(true)
    self.tipoffActive = true
  end
end

function ChatRoomCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  self.tipoffForbidden = nil
  if data ~= nil then
    local portrait = data:GetPortrait()
    local headData = Table_HeadImage[portrait]
    if portrait and portrait ~= 0 and headData and headData.Picture then
      self.headIcon:SetSimpleIcon(headData.Picture, headData.Frame)
      self.headIcon:SetPortraitFrame(data:GetPortraitFrame())
    elseif data.portraitImage then
      self.headIcon:SetSimpleIcon(data.portraitImage)
      self.headIcon:SetPortraitFrame(data:GetPortraitFrame())
    else
      TableUtility.TableClear(localData)
      localData.hairID = data:GetHair()
      localData.haircolor = data:GetHaircolor()
      localData.bodyID = data:GetBody()
      localData.headID = data:GetHead()
      localData.faceID = data:GetFace()
      localData.mouthID = data:GetMouth()
      localData.eyeID = data:GetEye()
      localData.gender = data:GetGender()
      localData.blink = data:GetBlink()
      localData.portraitframe = data:GetPortraitFrame()
      self.headIcon:SetData(localData)
    end
    self.selfName.text = data:GetName()
    local isReturnUser = data:IsReturnUser()
    self.returnSymbol:SetActive(isReturnUser)
    if not isReturnUser then
      local appellation = Table_Appellation[data:GetAppellation()]
      if appellation then
        self.adventure.text = appellation.Level
      else
        self.adventure.text = ""
      end
    else
      self.adventure.text = ""
    end
    local channelName = data:GetChannelName()
    if channelName then
      self.currentChannel.text = channelName
    else
      self.currentChannel.text = ChatRoomProxy.Instance.channelNames[data:GetChannel()]
    end
    self:UnloadEmoji()
    if data:GetExpressionType() == ChatRoomProxy.ExpressionType.Emoji then
      self:Hide(self.contentSprite)
      local expression = Table_Expression[data:GetExpressionId()]
      if expression and expression.NameEn and string.find(expression.NameEn, "Emoji_") then
        self:LoadEmoji(expression.NameEn)
      end
      return
    else
      self:Show(self.contentSprite)
    end
    self.tipoffActive = nil
    local voiceOffY = 0
    local hasPhoto = data:GetPhoto() ~= nil
    if hasPhoto then
      self.isPhotoCp = nil
      self:Show(self.photoTrans)
      self.speechBg:SetActive(false)
      self.chatContent.gameObject:SetActive(false)
      if data:IsPhotoLoaded() then
        self:LoadPhoto()
      else
        self:Hide(self.photoLoad)
        self:Show(self.photoShow)
        self:Hide(self.photoTex.gameObject)
      end
    else
      self:Hide(self.photoTrans)
      self.chatContent.gameObject:SetActive(true)
      self.voiceid = data:GetVoiceid()
      self.voicetime = data:GetVoicetime()
      if self.voiceid ~= 0 and self.voicetime ~= 0 then
        self.speechBg:SetActive(true)
        self.speechTime.text = string.format(ZhString.Chat_speechTime, self.voicetime)
        if not (BranchMgr.IsChina() or BranchMgr.IsTW()) or BackwardCompatibilityUtil.CompatibilityMode_Vspeech then
          local line = self:FindGO("line", self.speechBg)
          line:SetActive(false)
          self.chatContent.gameObject:SetActive(false)
        else
          voiceOffY = 46
        end
      else
        self.speechBg:SetActive(false)
      end
      LuaVector3.Better_Set(tempVector3, 0, voiceOffY, 0)
      LuaVector3.Better_Sub(self.contentPos, tempVector3, tempVector3)
      self.chatContent.transform.localPosition = tempVector3
      self.chatContent.text = data:GetStr()
      self.chatContent:ResizeCollider()
    end
    local size
    local cellType = data:GetCellType()
    if cellType == ChatTypeEnum.MySelfMessage or cellType == ChatTypeEnum.MyselfRedPacket then
      UIUtil.FitLabelHeight(self.chatContent, self.contentWidth)
      size = self.chatContent.localSize
    else
      size = self.chatContent.printedSize
    end
    local sizeY = size.y
    if 50 < sizeY then
      pos[2] = 26
    else
      pos[2] = 0
    end
    self.gameObject.transform.localPosition = pos
    self.contentSpriteBg.height = sizeY + 25 + voiceOffY
    if hasPhoto then
      self.contentSpriteBg.width = 135
      self.contentSpriteBg.height = 75
    elseif self.voiceid ~= 0 and self.voicetime ~= 0 then
      self.contentSpriteBg.width = self.contentWidth + 45
    else
      self.contentSpriteBg.width = size.x + 47
    end
    local charId = self.data:GetId()
    if self.contentSpriteBg.width < 127 then
      self.contentSpriteBg.width = 127
    end
    if GVoiceProxy.Instance:IsThisCharIdRealtimeVoiceAvailable(charId) then
      self.Voice.gameObject:SetActive(true)
    else
      self.Voice.gameObject:SetActive(false)
    end
  end
end

function ChatRoomCell:LoadPhoto()
  self:Show(self.photoLoad)
  self:Hide(self.photoShow)
  local tex = Game.HomeWallPicManager:TryGetThumbnail(self.data:GetPhoto())
  if tex then
    self:SetChatPhoto(tex)
  elseif not self.isPhotoCp then
    self:SetChatPhotoProgress(0)
  end
end

function ChatRoomCell:PlaySpeech()
  if self.voiceid ~= 0 and self.voicetime ~= 0 then
    local bytes, path = FunctionChatIO.Me():ReadChatSpeech(self.voiceid, self.data:GetTime())
    if bytes then
      FunctionChatSpeech.Me():PlayAudioByPath(path, self.voiceid)
    else
      ServiceChatCmdProxy.Instance:CallQueryVoiceUserCmd(self.voiceid)
    end
    ChatRoomProxy.Instance:ResetAutoSpeech()
  end
end

function ChatRoomCell:StartVoiceTween()
  self.voiceTween.enabled = true
  self.voiceTween:ResetToBeginning()
  self.voiceTween:PlayForward()
end

function ChatRoomCell:StopVoiceTween()
  if self.voiceTween.isActiveAndEnabled then
    self.voiceTween.enabled = false
    self.voiceTween.value = self.voiceTween.from
  end
end

function ChatRoomCell:ShowChatPhotoDetail()
  PersonalPictureDetailPanel.ViewType = UIViewType.PopUpLayer
  GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.PersonalPictureDetailPanel,
    viewdata = {
      PhotoData = self.data:GetPhoto(),
      readOnly = true
    }
  })
end

function ChatRoomCell:SetChatPhoto(texture)
  if texture then
    self:Hide(self.photoShow)
    self:Hide(self.photoLoad)
    self:Show(self.photoTex.gameObject)
    self.photoTex.mainTexture = texture
    self.isPhotoCp = true
  else
    self:SetChatPhotoError(ZhString.Chat_PhotoError)
  end
end

function ChatRoomCell:SetChatPhotoProgress(progress)
  self:Hide(self.photoShow)
  self:Show(self.photoLoad)
  self:Hide(self.photoTex.gameObject)
  self:Show(self.photoLoadBar.gameObject)
  self.photoLoadBar.value = progress / 100
  self.photoLoadInfo.text = progress .. "%"
end

function ChatRoomCell:SetChatPhotoError(text)
  self:Hide(self.photoShow)
  self:Show(self.photoLoad)
  self:Hide(self.photoTex.gameObject)
  self:Hide(self.photoLoadBar.gameObject)
  self.photoLoadInfo.text = text
end

function ChatRoomCell:CheckIsThisPhoto(photo)
  local chatPhoto = self.data:GetPhoto()
  if photo and chatPhoto and not self.isPhotoCp and Game.PictureWallManager:checkSamePicture(chatPhoto, photo) then
    return true
  end
end

function ChatRoomCell:ChatPhotoThumbnailPhDlPgCallback(note)
  if note.data and self:CheckIsThisPhoto(note.data.photoData) then
    self:SetChatPhotoProgress(note.data.progress)
  end
end

function ChatRoomCell:ChatPhotoThumbnailPhDlCpCallback(note)
  if note.data and self:CheckIsThisPhoto(note.data.photoData) then
    self:SetChatPhoto(note.data.texture)
  end
end

function ChatRoomCell:ChatPhotoThumbnailPhDlErCallback(note)
  if note.data and self:CheckIsThisPhoto(note.data.photoData) then
    self:SetChatPhotoError(ZhString.Chat_PhotoError)
  end
end

function ChatRoomCell:LoadEmoji(name)
  local resID = ResourcePathHelper.Emoji(name)
  if resID == self.emojiResID and not Slua.IsNull(self.emoji) then
    return
  end
  self.emojiResID = resID
  self.emoji = Game.AssetManager_UI:CreateSceneUIAsset(resID, self.emojiRoot)
  self.emoji.transform.localPosition = LuaGeometry.GetTempVector3(0, 0, 0)
  UIUtil.ChangeLayer(self.emoji, self.gameObject.layer)
  self.emoji.transform.localScale = LuaGeometry.GetTempVector3(1, 1, 1)
  self.emoji.transform.localRotation = LuaGeometry.GetTempQuaternion(0, 0, 0, 1)
  self.emoji.gameObject:SetActive(true)
  self.emoji.name = name
  local anim = self.emoji:GetComponent(SkeletonAnimation)
  anim.AnimationName = "ui_animation"
  anim:Reset()
  anim.loop = true
  SpineLuaHelper.PlayAnim(anim, "ui_animation", nil)
  local uispine = self.emoji:GetComponent(UISpine)
  uispine.depth = 10
end

function ChatRoomCell:UnloadEmoji()
  if self.emojiResID and not Slua.IsNull(self.emoji) then
    Game.GOLuaPoolManager:AddToSceneUIPool(self.emojiResID, self.emoji)
  end
  self.resID = nil
  self.emoji = nil
end

function ChatRoomCell:onShareItemClick(type)
  if type == ESHAREMSGTYPE.ESHARE_SPEC_ITEM_GET or type == ESHAREMSGTYPE.ESHARE_CARD then
    local itemData = ItemData.new(self.data.share_data.items[1][1], self.data.share_data.items[1][2])
    itemData:SetItemNum(self.data.share_data.items[1][3])
    if type == ESHAREMSGTYPE.ESHARE_CARD then
      itemData:SetCardLevel(self.data.share_data.items[1][4] or 0)
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.FloatAwardChatShareView,
      viewdata = {
        data = itemData,
        name = self.data:GetName()
      }
    })
  elseif type == ESHAREMSGTYPE.ESHARE_LOTTERY_TEN then
    local itemList = {}
    for i = 1, #self.data.share_data.items do
      local itemData = ItemData.new(self.data.share_data.items[i][1], self.data.share_data.items[i][2])
      itemData:SetItemNum(self.data.share_data.items[i][3])
      itemList[#itemList + 1] = itemData
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.LotteryResultChatShareView,
      viewdata = {
        data = itemList,
        name = self.data:GetName()
      }
    })
  elseif type == ESHAREMSGTYPE.ESHARE_REFINE then
    local itemData = self.data.share_data.items[1]
    local showType = FloatAwardView.checkEffectType(itemData)
    local showData = EffectShowDataWraper.new(itemData, nil, FloatAwardView.ShowType.ItemType, FloatAwardView.EffectFromType.RefineType)
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.RefineChatShareView,
      viewdata = {
        data = showData,
        name = self.data:GetName()
      }
    })
  elseif type == ESHAREMSGTYPE.ESHARE_NEW_EQUIP then
    local itemData = self.data.share_data.items[1]
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EquipConvertResultChatShareView,
      viewdata = {
        data = itemData,
        name = self.data:GetName()
      }
    })
  elseif type == ESHAREMSGTYPE.ESHARE_ENCHANT then
    local itemData = self.data.share_data.items[1]
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.EnchantNewChatShareView,
      viewdata = {
        enchantAttrList = itemData.enchantInfo.enchantAttrs,
        combineEffectList = itemData.enchantInfo.combineEffectlist,
        itemdata = itemData,
        name = self.data:GetName()
      }
    })
  elseif type == ESHAREMSGTYPE.ESHARE_EXTRACTION then
    local itemData = self.data.share_data.items[1]
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.MagicBoxExtractionChatShareView,
      viewdata = {
        data = itemData,
        name = self.data:GetName()
      }
    })
  elseif type == ESHAREMSGTYPE.ESHARE_COMPOSE_ARTIFACT then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PersonalArtifactChatShareView,
      viewdata = {
        data = self.data.share_data.items[1],
        name = self.data:GetName()
      }
    })
  elseif type == ESHAREMSGTYPE.ESHARE_REMOULD_ARTIFACT then
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PersonalArtifactRefreshChatShareView,
      viewdata = {
        data = self.data.share_data.items[1],
        name = self.data:GetName()
      }
    })
  end
end

function ChatRoomCell:TryReceivePostcard()
  if self.data and self.data:GetPostcard() then
    self:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.PostcardView,
      viewdata = {
        usageType = 2,
        postcard = self.data:GetPostcard(true)
      }
    })
    return true
  end
end
