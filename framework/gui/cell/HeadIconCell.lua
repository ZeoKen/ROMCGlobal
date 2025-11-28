BaseCell = autoImport("BaseCell")
HeadIconCell = class("HeadIconCell", BaseCell)
HeadIconCell.path = ResourcePathHelper.UICell("HeadIconCell")
HeadIconCell.partPath = "GUI/v1/cell/HeadIconCellParts/"
autoImport("Asset_Role")
HeadIconCell.State = {
  StandFace = 1,
  Blink = 2,
  Emoji = 3,
  UnActive = 4
}
HeadVoiceState = {
  Open = 1,
  Close = 2,
  Ban = 3
}
HeadIconCell.BlinkConfig = Table_Avatar[1]
HeadIconCell.BlinkTimeCheck = {2000, 5000}
local tempV3 = LuaVector3()
local tempSB = LuaStringBuilder.CreateAsTable()

function HeadIconCell:Init()
  self.active = true
  self.state = HeadIconCell.State.StandFace
  self:FindObjs()
  if self.effectContainer then
    self:DestroyChildren()
  end
  self.loaded = false
end

function HeadIconCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(HeadIconCell.path, parent)
    self:FindObjs()
  end
end

function HeadIconCell:CreatePart(pname)
  return self:LoadPreferb_ByFullPath(HeadIconCell.partPath .. pname, self.gameObject)
end

function HeadIconCell:SetClickEnable(val)
  if self.clickObj ~= nil then
    self.clickObj.gameObject:SetActive(val)
  end
end

function HeadIconCell:SetScale(scale)
  if self.gameObject then
    LuaVector3.Better_Set(tempV3, scale, scale, scale)
    self.gameObject.transform.localScale = tempV3
  end
end

function HeadIconCell:FindObjs()
  if self.gameObject then
    self.clickObj = self.gameObject:GetComponent(UIWidget)
  else
    return
  end
  self.frameSp = self:FindGO("Frame"):GetComponent(UISprite)
  self.simpleIcon = self:FindGO("SimpleHeadIcon"):GetComponent(UISprite)
  self.Voice = self:FindGO("Voice")
  self.Voice_VoiceOpen = self:FindGO("VoiceOpen", self.Voice)
  self.Voice_VoiceOpen_Bar1 = self:FindGO("Bar1", self.Voice_VoiceOpen)
  self.Voice_VoiceOpen_Bar2 = self:FindGO("Bar2", self.Voice_VoiceOpen)
  self.Voice_VoiceOpen_Bar3 = self:FindGO("Bar3", self.Voice_VoiceOpen)
  self.Voice_VoiceClose = self:FindGO("VoiceClose", self.Voice)
  if self.Voice_VoiceOpen then
    self.Voice_VoiceOpen:SetActive(false)
    self.Voice_VoiceClose:SetActive(false)
  end
  self.buffMask = self:FindGO("BuffMask"):GetComponent(UISprite)
  self.portraitFrame = self:FindGO("PortraitFrame"):GetComponent(UISprite)
  self.effectContainer = self:FindGO("effectContainer", self.portraitFrame.gameObject)
  self.effectWidget = self.effectContainer:GetComponent(UIWidget)
  self.loaded = false
  if not BackwardCompatibilityUtil.CompatibilityMode_V42 then
    self.effectComp = self.effectContainer:GetComponent(ChangeRqByTex)
    if self.effectComp then
      self.effectComp.useCommonMaterial = true
    end
  end
  self.portraitFrame.gameObject:SetActive(false)
  self.afkIcon = self:FindGO("AfkIcon"):GetComponent(UISprite)
  self.afkIcon.gameObject:SetActive(false)
end

function HeadIconCell:InitAvatarParts()
  if self.avatarPars ~= nil then
    return
  end
  self.avatarPars = self:CreatePart("HeadIconCell_FaceParts")
  self:SetIconLoaclPosXYZ(self.iPosX, self.iPosY, self.iPosZ)
  self.headAccessoryback = self:FindGO("Head_Accessory_back", self.avatarPars):GetComponent(UISprite)
  self.hairback = self:FindGO("Hair_back", self.avatarPars):GetComponent(UISprite)
  self.body = self:FindGO("Body", self.avatarPars):GetComponent(UISprite)
  self.baseFace = self:FindGO("BaseFace", self.avatarPars):GetComponent(UISprite)
  self.eye = self:FindGO("Eye", self.avatarPars):GetComponent(UISprite)
  self.hairfront = self:FindGO("Hair_front", self.avatarPars):GetComponent(UISprite)
  self.hairAccessory = self:FindGO("Hair_Accessory", self.avatarPars):GetComponent(UISprite)
  self.headAccessoryfront = self:FindGO("Head_Accessory_front", self.avatarPars):GetComponent(UISprite)
  self.faceAccessory = self:FindGO("Face_Accessory", self.avatarPars):GetComponent(UISprite)
  self.mouthAccessory = self:FindGO("Mouth_Accessory", self.avatarPars):GetComponent(UISprite)
  self.Voice = self:FindGO("Voice")
  self.Voice_VoiceOpen = self:FindGO("VoiceOpen", self.Voice)
  self.Voice_VoiceOpen_Bar1 = self:FindGO("Bar1", self.Voice_VoiceOpen)
  self.Voice_VoiceOpen_Bar2 = self:FindGO("Bar2", self.Voice_VoiceOpen)
  self.Voice_VoiceOpen_Bar3 = self:FindGO("Bar3", self.Voice_VoiceOpen)
  self.Voice_VoiceClose = self:FindGO("VoiceClose", self.Voice)
  if self.Voice_VoiceOpen then
    self.Voice_VoiceOpen:SetActive(false)
    self.Voice_VoiceClose:SetActive(false)
  end
  self.buffMask = self:FindGO("BuffMask"):GetComponent(UISprite)
  self:SetMinDepth(self.minDepth)
  self:SetActive(self.active, nil, true)
end

function HeadIconCell:SetVoiceState(voiceState)
  if voiceState == HeadVoiceState.Open then
    self.Voice:SetActive(true)
    self.Voice_VoiceOpen:SetActive(true)
    self.Voice_VoiceClose:SetActive(false)
  elseif voiceState == HeadVoiceState.Close then
    self.Voice:SetActive(false)
    self.Voice_VoiceOpen:SetActive(false)
    self.Voice_VoiceClose:SetActive(false)
  elseif voiceState == HeadVoiceState.Ban then
    self.Voice:SetActive(true)
    self.Voice_VoiceOpen:SetActive(false)
    self.Voice_VoiceClose:SetActive(true)
  end
end

function HeadIconCell:SetMinDepth(minDepth)
  if minDepth == nil then
    return
  end
  self.minDepth = minDepth
  self:SetDepth(self.clickObj, minDepth)
  self:SetDepth(self.frameSp, minDepth + 1)
  self:SetDepth(self.buffMask, minDepth + 2)
  self:SetDepth(self.simpleIcon, minDepth + 3)
  minDepth = minDepth + 3
  self:SetDepth(self.portraitFrame, minDepth + 5)
  self:SetDepth(self.effectWidget, minDepth + 6)
  if self.avatarPars == nil then
    return
  end
  self:SetDepth(self.headAccessoryback, minDepth + 2)
  self:SetDepth(self.hairback, minDepth + 3)
  self:SetDepth(self.body, minDepth + 4)
  self:SetDepth(self.baseFace, minDepth + 5)
  self:SetDepth(self.eye, minDepth + 6)
  self:SetDepth(self.hairfront, minDepth + 7)
  self:SetDepth(self.hairAccessory, minDepth + 8)
  self:SetDepth(self.headAccessoryfront, minDepth + 9)
  self:SetDepth(self.faceAccessory, minDepth + 10)
  self:SetDepth(self.mouthAccessory, minDepth + 11)
  self:SetDepth(self.afkIcon, minDepth + 12)
end

function HeadIconCell:SetDepth(widget, depth)
  if widget ~= nil then
    widget.depth = depth
  end
end

function HeadIconCell:SetCreatureID(guid)
  self.id = guid
  self:InitEmoji()
end

function HeadIconCell:InitEmoji()
  if self.id and self.syncEmoji then
    local initEmojiID = FunctionPlayerHead.Me():GetEmojiCache(self.id)
    if initEmojiID then
      self:TryPlayEmojiID(initEmojiID)
    end
  end
end

function HeadIconCell:SetEnabelEmojiFace(val)
  self.enableEmojiFace = val
  if not self.enableEmojiFace then
    self:ForceToStandFace()
  end
end

function HeadIconCell:SetSimpleIcon(icon, frameType)
  self:SetFrame(frameType)
  self:SetEnabelEmojiFace(false)
  self:Hide(self.avatarPars)
  self:Show(self.simpleIcon.gameObject)
  if self.simpleIcon ~= nil and icon ~= nil then
    IconManager:SetFaceIcon(icon, self.simpleIcon)
  end
  self:SetGME()
end

function HeadIconCell:ShouldShowAfkIcon()
  return self.data.afk and self.data.afk ~= 0 and true or false
end

function HeadIconCell:SetData(data)
  self.data = data
  local hairID, headID, faceID, mouthID, bodyID, eyeID = self:ParseDisplayLogic(self.data.hairID, self.data.headID, self.data.faceID, self.data.mouthID, self.data.bodyID, self.data.eyeID, self.data.gender)
  local bodydata = Table_Body[bodyID]
  if bodydata ~= nil and bodydata.HeadIcon ~= "" then
    self:SetSimpleIcon(bodydata.HeadIcon)
    self:SetPortraitFrame(self.data.portraitframe)
    self.afkIcon.gameObject:SetActive(self:ShouldShowAfkIcon())
    return
  end
  self:InitAvatarParts()
  self:SetEnabelEmojiFace(true)
  if self.data ~= nil and self.data.id ~= nil then
    self:SetCreatureID(self.data.id)
  end
  self:Show(self.avatarPars)
  self:Hide(self.simpleIcon.gameObject)
  local isDoram = self.data.professionID and ProfessionProxy.IsDoramRace(self.data.professionID) or Game.Myself and Game.Myself.data:IsDoram() or false
  self:SetHairColor(self.data.hairID, self.data.haircolor)
  self:SetHair(hairID)
  self:SetHairAccessory(hairID)
  self:SetFace(self.data.gender, self:SetBody(bodyID))
  self:SetHeadAccessory(headID, isDoram)
  self:SetFaceAccessory(faceID, isDoram)
  self:SetMouthAccessory(mouthID, isDoram)
  self:SetEye(eyeID)
  if self.data.blink ~= nil then
    self:SetBlinkEnable(self.data.blink)
  end
  self:SetFrame()
  self:SetPortraitFrame(self.data.portraitframe)
  self:SetGME()
  self.afkIcon.gameObject:SetActive(self:ShouldShowAfkIcon())
  self.isDoram = isDoram
end

function HeadIconCell:SetGME()
end

function HeadIconCell:SetAfkIcon(afk)
  self.afkIcon.gameObject:SetActive(afk and afk ~= 0 and true or false)
end

local parts = Asset_Role.CreatePartArray()
local PartIndex = Asset_Role.PartIndexEx

function HeadIconCell:ParseDisplayLogic(hairID, headID, faceID, mouthID, bodyID, eyeID, gender)
  parts[PartIndex.Hair] = hairID or 0
  parts[PartIndex.Head] = headID or 0
  parts[PartIndex.Face] = faceID or 0
  parts[PartIndex.Mouth] = mouthID or 0
  parts[PartIndex.Body] = bodyID or 0
  parts[PartIndex.Eye] = eyeID or 0
  Asset_Role.PreprocessParts(parts, gender)
  return parts[PartIndex.Hair], parts[PartIndex.Head], parts[PartIndex.Face], parts[PartIndex.Mouth], parts[PartIndex.Body], parts[PartIndex.Eye]
end

function HeadIconCell:SetClickWidthHeight(w, h)
  if self.clickObj ~= nil then
    self.clickObj.width = w
    self.clickObj.height = h
  end
end

function HeadIconCell:AddDragScrollview()
  self.dragScrollView = self.gameObject:GetComponent(UIDragScrollView)
  if not self.dragScrollView then
    self.dragScrollView = self.gameObject:AddComponent(UIDragScrollView)
  end
end

function HeadIconCell:MakePixelPerfect(uiwidget)
  if uiwidget ~= nil then
    uiwidget:MakePixelPerfect()
  end
end

local FrameBgMap = {
  [1] = "com_bg_head4",
  [2] = "com_bg_head_5"
}

function HeadIconCell:SetFrame(frameType)
  if frameType and FrameBgMap[frameType] then
    self.frameSp.spriteName = FrameBgMap[frameType]
    return
  end
  self.frameSp.spriteName = "com_bg_head"
end

function HeadIconCell:SetHair(hairID)
  if self.hairStyleID == hairID then
    return
  end
  if hairID ~= nil then
    self.hairStyleID = hairID
    local hair = Table_HairStyle[hairID]
    if hair then
      self:Show(self.hairback.gameObject)
      self:Show(self.hairfront.gameObject)
      if hair.HairBack then
        self:SetSpriteName(self.hairback, hair.HairBack)
      else
        errorLog(string.format("HeadIconCell SetHair : %s HairBack = nil", tostring(hairID)))
      end
      if hair.HairFront then
        self:SetSpriteName(self.hairfront, hair.HairFront)
      else
        errorLog(string.format("HeadIconCell SetHair : %s HairFront = nil", tostring(hairID)))
      end
    else
      self:Hide(self.hairback.gameObject)
      self:Hide(self.hairfront.gameObject)
    end
  else
  end
end

function HeadIconCell:SetHairAccessory(hairID)
  if self.hairAccessoryID == hairID then
    return
  end
  if hairID ~= nil then
    self.hairAccessoryID = hairID
    local hair = Table_HairStyle[hairID]
    if hair then
      self:Show(self.hairAccessory.gameObject)
      if hair.HairAdornment then
        self:SetSpriteName(self.hairAccessory, hair.HairAdornment)
      else
        errorLog(string.format("HeadIconCell SetHairAccessory : %s HairAdornment = nil", tostring(hairID)))
      end
    else
      self:Hide(self.hairAccessory.gameObject)
    end
  else
  end
end

function HeadIconCell:SetHairColor(hairID, hairColorID, refresh)
  hairColorID = hairColorID or 0
  if hairColorID ~= nil then
    self.hairID = hairID
    self.hairColorID = hairColorID
    local hair = Table_HairStyle[hairID]
    if self.active then
      if hair then
        if hair.PaintColor_Parsed then
          local c = hair.PaintColor_Parsed[hairColorID]
          local specialHairColor = GameConfig.HairColor and GameConfig.HairColor[hairID]
          if c then
            self.hairback.color = c
            self.hairfront.color = c
          elseif nil ~= specialHairColor then
            local success, color = ColorUtil.TryParseHexString(specialHairColor.avater)
            if success then
              self.hairback.color = color
              self.hairfront.color = color
            end
          end
        else
          errorLog("HeadIconCell SetHairColor : PaintColor_Parsed = nil")
        end
      elseif not refresh then
      end
    end
  elseif not refresh then
  end
end

function HeadIconCell:SetBody(bodyID)
  if self.bodyID == bodyID then
    return
  end
  if bodyID ~= nil then
    local oriBody = Table_Body[self.bodyID]
    local body = Table_Body[bodyID]
    self.bodyID = bodyID
    if body then
      local bodyStr = body.AvatarBody
      if bodyStr == nil or bodyStr == "" then
        bodyStr = "Body_" .. body.Texture
      end
      local texturePath = PictureManager.Config.Pic.UI .. "square_mask"
      Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, self.body)
      self:SetSpriteName(self.body, bodyStr)
      self.body:SetMaskPath(UIMaskConfig.SquareHeadMask)
    else
    end
    if (oriBody and oriBody.AvatarBranch or 0) ~= (body and body.AvatarBranch or 0) then
      return true
    end
  else
  end
  return true
end

function HeadIconCell:SetFace(sex, isRaceChanged)
  local isSexChanged
  if sex ~= nil and self.sex ~= sex then
    self.sex = sex
    isSexChanged = 1
  else
  end
  if isSexChanged or isRaceChanged then
    self:RefreshFace()
  end
end

function HeadIconCell:SetHeadAccessory(headAccessory, isDoram)
  if self.headID == headAccessory and isDoram == self.isDoram then
    return
  end
  self.headID = headAccessory
  if headAccessory and headAccessory ~= 0 then
    local assesories = Table_Assesories[headAccessory]
    if assesories then
      self:Show(self.headAccessoryback.gameObject)
      self:Show(self.headAccessoryfront.gameObject)
      if assesories.Back then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadAccessoryBackIcon(assesories.Back .. strAppend, self.headAccessoryback) then
            isSet = IconManager:SetHeadAccessoryBackIcon(assesories.Back, self.headAccessoryback)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadAccessoryBackIcon(assesories.Back, self.headAccessoryback)
        end
        self.headAccessoryback.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.headAccessoryback)
      end
      if assesories.Front then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadAccessoryFrontIcon(assesories.Front .. strAppend, self.headAccessoryfront) then
            isSet = IconManager:SetHeadAccessoryFrontIcon(assesories.Front, self.headAccessoryfront)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadAccessoryFrontIcon(assesories.Front, self.headAccessoryfront)
        end
        self.headAccessoryfront.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.headAccessoryfront)
      end
      return
    end
  end
  self:Hide(self.headAccessoryback.gameObject)
  self:Hide(self.headAccessoryfront.gameObject)
end

function HeadIconCell:SetFaceAccessory(faceAccessory, isDoram)
  if self.faceID ~= nil then
    self.faceBlinkTag = true
  end
  if self.faceID == faceAccessory and isDoram == self.isDoram then
    return
  end
  self.faceID = faceAccessory
  if faceAccessory and faceAccessory ~= 0 then
    local assesories = Table_Assesories[faceAccessory]
    if assesories then
      self:Show(self.faceAccessory.gameObject)
      if assesories.Front then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadFaceMouthIcon(assesories.Front .. strAppend, self.faceAccessory) then
            isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.faceAccessory)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.faceAccessory)
        end
        self.faceAccessory.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.faceAccessory)
      end
      return
    end
  end
  self.faceBlinkTag = false
  self:Hide(self.faceAccessory.gameObject)
end

function HeadIconCell:SetMouthAccessory(mouthAccessory, isDoram)
  if self.mouthID == mouthAccessory and isDoram == self.isDoram then
    return
  end
  self.mouthID = mouthAccessory
  if mouthAccessory and mouthAccessory ~= 0 then
    local assesories = Table_Assesories[mouthAccessory]
    if assesories then
      self:Show(self.mouthAccessory.gameObject)
      if assesories.Front then
        local isSet = false
        if isDoram then
          local strAppend = "_d"
          if not IconManager:SetHeadFaceMouthIcon(assesories.Front .. strAppend, self.mouthAccessory) then
            isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.mouthAccessory)
          else
            isSet = true
          end
        else
          isSet = IconManager:SetHeadFaceMouthIcon(assesories.Front, self.mouthAccessory)
        end
        self.mouthAccessory.gameObject:SetActive(isSet)
        self:MakePixelPerfect(self.mouthAccessory)
      end
      return
    end
  end
  self:Hide(self.mouthAccessory.gameObject)
end

function HeadIconCell:SetEye(eye)
  if self.eyeID == eye then
    return
  end
  self.eyeID = eye
  if eye and eye ~= 0 then
    self:Show(self.eye.gameObject)
    local data = Table_Eye[eye]
    if data and data.HeadImage then
      local isSet = IconManager:SetEyeIcon(data.HeadImage, self.eye)
      self.eye.gameObject:SetActive(isSet)
      self:MakePixelPerfect(self.eye)
      if 0 < #data.EyeColor then
        local hasColor, eyeColor = ColorUtil.TryParseFromNumber(data.EyeColor[1])
        self.eye.color = eyeColor
      end
    end
  else
    self:Hide(self.eye.gameObject)
  end
end

function HeadIconCell:SetSpriteName(sprite, name)
  local isSet = IconManager:SetBodyIcon(name, sprite)
  sprite.gameObject:SetActive(isSet)
  self:MakePixelPerfect(sprite)
end

function HeadIconCell:SetActive(val, emojiChange, force)
  if self.active ~= val or force then
    self.active = val
    if val then
      if self.avatarPars then
        ColorUtil.WhiteUIWidget(self.headAccessoryback)
        ColorUtil.WhiteUIWidget(self.body)
        ColorUtil.WhiteUIWidget(self.baseFace)
        ColorUtil.WhiteUIWidget(self.eye)
        ColorUtil.WhiteUIWidget(self.hairAccessory)
        ColorUtil.WhiteUIWidget(self.headAccessoryfront)
        ColorUtil.WhiteUIWidget(self.faceAccessory)
        ColorUtil.WhiteUIWidget(self.mouthAccessory)
        self:SetHairColor(self.hairID, self.hairColorID, true)
      end
      ColorUtil.WhiteUIWidget(self.simpleIcon)
    else
      if self.avatarPars then
        ColorUtil.ShaderGrayUIWidget(self.headAccessoryback)
        ColorUtil.ShaderGrayUIWidget(self.hairback)
        ColorUtil.ShaderGrayUIWidget(self.body)
        ColorUtil.ShaderGrayUIWidget(self.baseFace)
        ColorUtil.ShaderGrayUIWidget(self.eye)
        ColorUtil.ShaderGrayUIWidget(self.hairfront)
        ColorUtil.ShaderGrayUIWidget(self.hairAccessory)
        ColorUtil.ShaderGrayUIWidget(self.headAccessoryfront)
        ColorUtil.ShaderGrayUIWidget(self.faceAccessory)
        ColorUtil.ShaderGrayUIWidget(self.mouthAccessory)
      end
      ColorUtil.ShaderLightGrayUIWidget(self.simpleIcon)
    end
  end
  if emojiChange then
    if val then
      if self.state == HeadIconCell.State.UnActive then
        self:SetFaceState(HeadIconCell.State.StandFace)
      end
    else
      self:SetFaceState(HeadIconCell.State.UnActive)
    end
  end
end

function HeadIconCell:SetBlinkEnable(val)
  if self.eye ~= nil and not self.eye.gameObject.activeSelf then
    val = false
  end
  if self.faceAccessory ~= nil and self.faceAccessory.gameObject.activeSelf then
    val = false
  end
  if self.faceBlinkTag then
    val = false
  end
  if self.baseFace ~= nil and not self.baseFace.gameObject.activeSelf then
    val = false
  end
  self.blink = val
  if val then
    self:ResetBlinkTime()
    self.timeTick = TimeTickManager.Me():CreateTick(0, 500, self.TryBlink, self, 100)
  else
    if self.state == HeadIconCell.State.Blink then
      self:SetFaceState(HeadIconCell.State.StandFace)
    end
    if self.timeTick then
      self.timeTick:Destroy()
      self.timeTick = nil
    end
  end
end

function HeadIconCell:ResetBlinkTime()
  self.blinkInteval = 0
  self.blinkTime = math.random(HeadIconCell.BlinkTimeCheck[1], HeadIconCell.BlinkTimeCheck[2])
end

function HeadIconCell:TryBlink(delta)
  if Game.GameObjectUtil:ObjectIsNULL(self.gameObject) and self.timeTick then
    self.timeTick:Destroy()
    self.timeTick = nil
  end
  self.blinkInteval = self.blinkInteval + delta
  if self.blinkInteval >= self.blinkTime then
    self:ResetBlinkTime()
    if self.state == HeadIconCell.State.StandFace and not self.isEmojiInCD and math.random(1, 10000) <= HeadIconCell.BlinkConfig.Probability then
      self:SetFaceState(HeadIconCell.State.Blink)
      self:RemoveLt1()
      self.lt = TimeTickManager.Me():CreateOnceDelayTick(HeadIconCell.BlinkConfig.Duration * 1000, function(owner, deltaTime)
        self:RemoveLt1()
        if self.state == HeadIconCell.State.Blink then
          self:SetFaceState(HeadIconCell.State.StandFace)
        end
      end, self, 101)
    end
  end
end

function HeadIconCell:RemoveLt1()
  if self.lt then
    self.lt:Destroy()
    self.lt = nil
  end
end

function HeadIconCell:RemoveLt2()
  if self.lt2 then
    self.lt2:Destroy()
    self.lt2 = nil
  end
end

function HeadIconCell:RefreshFace()
  if Slua.IsNull(self.gameObject) then
    return
  end
  if self.avatarPars == nil then
    return
  end
  local face
  if self.state == HeadIconCell.State.Emoji then
    local config = Table_Avatar[self.currentEmojiID]
    if config then
      face = config.NameEn
      self:Hide(self.eye.gameObject)
    end
  else
    self.currentEmojiID = nil
    if self.state == HeadIconCell.State.StandFace then
      face = "Head_stand"
      self:Show(self.eye.gameObject)
    elseif self.state == HeadIconCell.State.Blink then
      face = "Head_closeeye"
      self:Hide(self.eye.gameObject)
    elseif self.state == HeadIconCell.State.UnActive then
      face = "Head_closeeye"
      self:Hide(self.eye.gameObject)
    end
  end
  if face ~= nil then
    tempSB:Clear()
    tempSB:Append(face)
    local config = Table_Body[self.bodyID]
    if config and config.AvatarBranch == 1 then
      tempSB:Append("_D")
    end
    tempSB:Append("_")
    tempSB:Append(self.sex == RoleConfig.Gender.Male and "M" or "F")
    local facepic = config and config.Facepic
    if not facepic or facepic == 0 then
      self:SetSpriteName(self.baseFace, tempSB:ToString())
      self:MakePixelPerfect(self.baseFace)
    else
      self:Hide(self.baseFace.gameObject)
    end
  end
end

function HeadIconCell:SetFaceState(state)
  self.state = state
  self:RefreshFace()
end

function HeadIconCell:ForceToStandFace()
  self.isEmojiInCD = false
  self:SetFaceState(HeadIconCell.State.StandFace)
end

function HeadIconCell:TryPlayEmojiID(emojiID)
  if self.enableEmojiFace then
    local config = Table_Avatar[emojiID]
    if config and self:IsPlayEmoji(config) then
      local duration = config.Duration
      local cd = 1
      if self.currentEmojiID ~= emojiID then
        self.currentEmojiID = emojiID
        self:SetFaceState(HeadIconCell.State.Emoji)
        self.isEmojiInCD = true
        if duration ~= 0 then
          self:RemoveLt1()
          self.lt = TimeTickManager.Me():CreateOnceDelayTick(duration * 1000, function(owner, deltaTime)
            if self.state == HeadIconCell.State.Emoji then
              self:SetFaceState(HeadIconCell.State.StandFace)
            end
            self:RemoveLt1()
          end, self, 101)
          self:RemoveLt2()
          self.lt2 = TimeTickManager.Me():CreateOnceDelayTick(duration * 1000 + 1000, function(owner, deltaTime)
            self.isEmojiInCD = false
            self:RemoveLt2()
          end, self, 102)
        end
      end
    end
  end
end

function HeadIconCell:IsPlayEmoji(config)
  if self.state < HeadIconCell.State.Emoji and not self.isEmojiInCD then
    return true
  elseif self.state == HeadIconCell.State.Emoji then
    local curConfig = Table_Avatar[self.currentEmojiID]
    if curConfig and config.Priority and curConfig.Priority and config.Priority < curConfig.Priority then
      return true
    end
  end
  return false
end

function HeadIconCell:ServerSyncEmoji(sdata)
  if sdata.charid == self.id then
    self:TryPlayEmojiID(sdata.expressionid)
  end
end

function HeadIconCell:ServerSyncDefautEmoji(sdata)
  if sdata.charid == self.id and self.state ~= HeadIconCell.State.UnActive then
    self:ForceToStandFace()
  end
end

function HeadIconCell:EnableBlinkEye()
  self:SetBlinkEnable(true)
end

function HeadIconCell:HideFrame()
  self.frameSp.gameObject:SetActive(false)
end

function HeadIconCell:PlayDebuffEffect(sdata)
  if sdata == self.id then
    self.buffMask.gameObject:SetActive(true)
  end
end

function HeadIconCell:CloseDebuffEffect(sdata)
  if sdata == self.id then
    self.buffMask.gameObject:SetActive(false)
  end
end

function HeadIconCell:InitConfig()
  self.curmapid = SceneProxy.Instance:GetCurRaidID()
  local tgConfig = Table_TeamGroupRaid[self.curmapid]
  if tgConfig then
    self.ConfigThanatos = GameConfig.Thanatos[tgConfig.Difficulty]
  end
end

function HeadIconCell:OnAdd()
  self.syncEmoji = true
  self:InitEmoji()
  FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.PlayDefaultEmojiEvent, self.ServerSyncDefautEmoji, self)
  FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.PlayEmojiEvent, self.ServerSyncEmoji, self)
  FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.EnableBlinkEye, self.EnableBlinkEye, self)
  FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.PlayDebuffEffect, self.PlayDebuffEffect, self)
  FunctionPlayerHead.Me():AddEventListener(FunctionPlayerHead.CloseDebuffEffect, self.CloseDebuffEffect, self)
end

function HeadIconCell:OnRemove()
  self:RemoveLt1()
  self:RemoveLt2()
  self:DestroyChildren()
  self.syncEmoji = false
  FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.PlayDefaultEmojiEvent, self.ServerSyncDefautEmoji, self)
  FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.PlayEmojiEvent, self.ServerSyncEmoji, self)
  FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.EnableBlinkEye, self.EnableBlinkEye, self)
  FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.PlayDebuffEffect, self.PlayDebuffEffect, self)
  FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.CloseDebuffEffect, self.CloseDebuffEffect, self)
  FunctionPlayerHead.Me():RemoveEventListener(FunctionPlayerHead.GMEVoiceEvent, self.UpdateGMEState, self)
  TimeTickManager.Me():ClearTick(self)
end

function HeadIconCell:Show(go)
  if go == nil then
    return
  end
  go:SetActive(true)
end

function HeadIconCell:Hide(go)
  if go == nil then
    return
  end
  go:SetActive(false)
end

function HeadIconCell:SetIconLoaclPosXYZ(x, y, z)
  x = x or 0
  y = y or 0
  z = z or 0
  if self.iconSet_dirty == false then
    return
  end
  self.iconSet_dirty = true
  self.iPosX = x
  self.iPosY = y
  self.iPosZ = z
  LuaVector3.Better_Set(tempV3, x, y, z)
  if self.avatarPars ~= nil then
    self.avatarPars.transform.localPosition = tempV3
    self.iconSet_dirty = false
  end
  self.simpleIcon.transform.localPosition = tempV3
end

function HeadIconCell:DisableBoxCollider(b)
  if self.clickObj then
    local boxcollider = self.clickObj:GetComponent(BoxCollider)
    if boxcollider then
      boxcollider.enabled = b
    end
  end
end

function HeadIconCell:SetPortraitFrame(id)
  self:ResetPortraitFrame()
  if id then
    local data = Table_UserPortraitFrame[id]
    if data then
      IconManager:SetAvatarIcon(data.Icon, self.portraitFrame)
      if not self.portraitFrame.gameObject.activeInHierarchy then
        self.portraitFrame.gameObject:SetActive(true)
      end
      if data.Effect and data.Effect ~= "" then
        if not self.loaded then
          self.pEffect = self:PlayEffectByFullPath("UI/" .. data.Effect, self.effectContainer, false, function()
            if self.effectComp then
              self.effectComp.excute = false
            end
          end)
          self.loaded = true
        end
        if not self.effectContainer.activeInHierarchy then
          self.effectContainer:SetActive(true)
        end
      else
        self.effectContainer:SetActive(false)
      end
      return
    end
  end
  self.portraitFrame.gameObject:SetActive(false)
  self.effectContainer:SetActive(false)
  IconManager:SetAvatarIcon("", self.portraitFrame)
end

function HeadIconCell:DestroyChildren()
  if self.pEffect then
    self.pEffect:Destroy()
    self.pEffect = nil
  end
end

function HeadIconCell:SetPortraitFrameDepth(baseDepth)
  baseDepth = baseDepth or 1
  self:SetDepth(self.portraitFrame, baseDepth + 1)
  self:SetDepth(self.effectWidget, baseDepth + 2)
end

function HeadIconCell:SetAfkIconDepth(depth)
  depth = depth or 1
  self:SetDepth(self.afkIcon, depth)
end

function HeadIconCell:ResetPortraitFrame()
  if self.effectContainer then
    self:DestroyChildren()
    self.loaded = false
  end
end

function HeadIconCell:CalOffset(sprt, rate)
  local msprite = sprt:GetAtlasSprite()
  if msprite == nil then
    return
  end
  local left = msprite.paddingLeft
  local bottom = msprite.paddingBottom
  local x = 1.0 * left / msprite.width
  local y = 1.0 * bottom / msprite.height
  local w = msprite.width / 116.0
  local h = msprite.height / 116.0
  sprt:SetOffsetParams(x, y, w, h)
  sprt.OpenMask = true
  sprt.OpenCompress = false
  sprt.NeedOffset2 = true
end

function HeadIconCell:Cal(sprt, name, maskName, depthChange)
  local msprite = sprt:GetAtlasSprite()
  if msprite == nil then
    return
  end
  sprt:SetMaskPath(maskName)
  local texturePath = PictureManager.Config.Pic.UI .. "square_mask"
  Game.AssetManager_UI:LoadAsset(texturePath, Texture, HeadIconCell.LoadTextureCallback, sprt)
  sprt.OpenMask = true
  sprt.OpenCompress = false
  sprt.NeedOffset2 = true
  local left = msprite.paddingLeft
  local bottom = msprite.paddingBottom
  local x = 1.0 * left / msprite.width
  local y = 1.0 * bottom / msprite.height
  local w = msprite.width / 116.0
  local h = msprite.height / 116.0
  sprt:SetOffsetParams(x, y, w, h)
end

function HeadIconCell.LoadTextureCallback(sprt, asset)
  sprt:SetMasktexture(asset)
end

function HeadIconCell:OnCellDestroy()
  if self.effectContainer then
    self:DestroyChildren()
  end
end

MyHeadIconCell = class("MyHeadIconCell", HeadIconCell)

function MyHeadIconCell:Refresh(pFrame)
  local myself = Game.Myself
  if myself then
    local userData = myself.data.userdata
    if userData then
      local hairID = userData:Get(UDEnum.HAIR) or nil
      local bodyID = userData:Get(UDEnum.BODY) or nil
      local sex = userData:Get(UDEnum.SEX) or nil
      local haircolor = userData:Get(UDEnum.HAIRCOLOR) or nil
      local headID = userData:Get(UDEnum.HEAD) or nil
      local faceID = userData:Get(UDEnum.FACE) or nil
      local mouthID = userData:Get(UDEnum.MOUTH) or nil
      local eye = userData:Get(UDEnum.EYE) or nil
      local portraitFrame = pFrame or userData:Get(UDEnum.PORTRAIT_FRAME) or nil
      self:SetHairColor(hairID, haircolor)
      hairID, headID, faceID, mouthID = self:ParseDisplayLogic(hairID, headID, faceID, mouthID, sex)
      self:SetHair(hairID)
      self:SetHairAccessory(hairID)
      self:SetBody(bodyID)
      self:SetFace(sex)
      self:SetHeadAccessory(headID)
      self:SetFaceAccessory(faceID)
      self:SetMouthAccessory(mouthID)
      self:SetEye(eye)
      self:SetPortraitFrame(portraitFrame)
    end
  end
end
