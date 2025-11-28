local BaseCell = autoImport("BaseCell")
MemoryPageCell = class("MemoryPageCell", BaseCell)
autoImport("PopupGridList")
local tempV3 = LuaVector3.Zero()

function MemoryPageCell:Init()
  self.picTexture = self:FindGO("Texture"):GetComponent(UITexture)
  self.textScrollView = self:FindGO("TextScrollView"):GetComponent(UIScrollView)
  self.textPanel = self:FindGO("TextScrollView"):GetComponent(UIPanel)
  self.text = self:FindGO("Text", self.textScrollView.gameObject):GetComponent(UILabel)
  self.title = self:FindGO("Title"):GetComponent(UILabel)
  self.logo1 = self:FindGO("ROLogo1")
  self.logo2 = self:FindGO("ROLogo2")
  self.QRCode = self:FindGO("QRCode"):GetComponent(UITexture)
  self.bgTexture = self:FindGO("BgTexture"):GetComponent(UITexture)
  self.picBg = self:FindGO("PicBg")
  self.infoBg = self:FindGO("InfoBg")
  self.playerName = self:FindGO("PlayerName"):GetComponent(UILabel)
  self.serverName = self:FindGO("ServerName"):GetComponent(UILabel)
  self.guildName = self:FindGO("GuildName"):GetComponent(UILabel)
  self.editBtn = self:FindGO("EditBtn")
  self:AddClickEvent(self.editBtn, function()
    self:PassEvent(UICellEvent.OnMidBtnClicked, self)
  end)
  self.titlePop = self:FindGO("TitlePop")
  self.titleArrow = self:FindGO("tabsArrow", self.titlePop)
  self.title_Bg = self:FindGO("ItemTabsBg", self.titlePop)
  self.title_lockBg = self:FindGO("ItemTabsBg_Lock", self.titlePop)
  self.texture = self:FindGO("Texture"):GetComponent(UITexture)
  self.key = self:FindGO("Key"):GetComponent(UITexture)
  PictureManager.Instance:SetUI("anniversarymemories_bg_1", self.bgTexture)
  PictureManager.Instance:SetUI("mall_bg_key", self.key)
  PictureManager.Instance:SetUI("anniversarymemories_bg_qrcode", self.QRCode)
end

function MemoryPageCell:InitInfoPart()
  if self.targetCell then
    return
  end
  local headContainer = self:FindGO("HeadContainer")
  local cellObj = Game.AssetManager_UI:CreateAsset(ResourcePathHelper.UICell("PlayerHeadCell"), headContainer)
  self.targetCell = PlayerFaceCell.new(cellObj)
  self.targetCell:HideHpMp()
  self.targetCell:HideLevel()
  self.headData = HeadImageData.new()
  self.headData:TransByMyself()
  self.targetCell:SetData(self.headData)
  self.playerName.text = Game.Myself.data:GetName()
  local serverData = FunctionLogin.Me():getCurServerData()
  self.serverName.text = serverData and serverData.name or "服务器名字"
  local guildData = GuildProxy.Instance.myGuildData
  self.guildName.text = guildData and guildData.name
end

function MemoryPageCell:InitTitlePop()
  if self.titlePopupList then
    return
  end
  self.titlePopupList = PopupGridList.new(self.titlePop, function(self, data)
    self:OnClickTitle(data)
  end, self, 40, nil, 3)
  local validIndexes = YearMemoryProxy.Instance:GetValidIndexesByVersion(self.version)
  local popupItems = {}
  if validIndexes and #validIndexes then
    for i = 1, #validIndexes do
      local id = validIndexes[i]
      local info = Table_YearMemoryLine[validIndexes[i]]
      if info and info.Title and info.Title ~= "" then
        local data = ReusableTable.CreateTable()
        data.name = info.Title
        data.id = id
        table.insert(popupItems, data)
      end
    end
  end
  self.titlePopupList:SetData(popupItems, true)
  local data = YearMemoryProxy.Instance:GetMemoryStatus(self.version)
  local titleID = data and data.title
  if titleID and titleID ~= 0 then
    xdlog("已存入的id", titleID)
    local info = Table_YearMemoryLine[titleID]
    self.titlePopupList.labCurrent.text = info and info.Title
    self.titlePopupList.value = info and info.Title
  end
end

function MemoryPageCell:OnClickTitle(data)
  if data and data.id then
    xdlog("发送数据", data.id)
    YearMemoryProxy.Instance:CallSetYearMemoryTitleUserCmd(self.version, data.id, nil)
  end
end

function MemoryPageCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(self.data ~= nil)
  self.version = data and data.version
  self.page = data and data.page
  self.isSummary = data and data.summary
  local isFirstShow = data and data.firstShow
  if isFirstShow then
    self:PlayEnterTween()
  end
  if self.isSummary then
    self.infoBg:SetActive(true)
    self.picBg:SetActive(false)
    self.editBtn:SetActive(true)
    self:InitInfoPart()
    self.titlePop:SetActive(true)
    self:InitTitlePop()
    self.logo1.transform.localPosition = LuaGeometry.GetTempVector3(313, -108, 0)
    self.logo2.transform.localPosition = LuaGeometry.GetTempVector3(212, -99, 0)
    self.title.text = ZhString.ActivityIntegration_YearMemorySummary
    local unlockData = YearMemoryProxy.Instance:GetMemoryStatus(self.version)
    local keypoints = unlockData and unlockData.keypoints
    if keypoints and 0 < #keypoints then
      local str = ""
      for i = 1, #keypoints do
        local lineInfo = Table_YearMemoryLine[keypoints[i]]
        if lineInfo then
          local descStr = OverSea.LangManager.Instance():GetLangByKey(lineInfo.Desc)
          descStr = YearMemoryProxy.Instance:AdaptReplaceMark(self.version, descStr)
          if str ~= "" then
            str = str .. [[


]]
          end
          str = str .. descStr
        end
      end
      self.text.text = str
    else
      local versionData = YearMemoryProxy.Instance:GetVersionData(self.version)
      local totalList = {}
      local pages = versionData.pages
      for page, info in pairs(pages) do
        local indexes = info.indexes
        for i = 1, #indexes do
          local lineInfo = Table_YearMemoryLine[indexes[i]]
          if lineInfo and lineInfo.Preview and lineInfo.Preview ~= "" then
            local descStr = OverSea.LangManager.Instance():GetLangByKey(lineInfo.Desc)
            if YearMemoryProxy.Instance:HasReplaceInfo(self.version, descStr) then
              table.insert(totalList, indexes[i])
            end
          end
        end
      end
      local randomList = {}
      if totalList and #totalList <= 3 then
        TableUtility.ArrayShallowCopy(randomList, totalList)
      else
        for i = 1, 3 do
          local randomResult = totalList[math.random(1, #totalList)]
          table.insert(randomList, randomResult)
          TableUtility.ArrayRemove(totalList, randomResult)
        end
      end
      local str = ""
      for i = 1, #randomList do
        local lineInfo = Table_YearMemoryLine[randomList[i]]
        local descStr = YearMemoryProxy.Instance:AdaptReplaceMark(self.version, OverSea.LangManager.Instance():GetLangByKey(lineInfo.Desc))
        if str ~= "" then
          str = str .. [[


]]
        end
        str = str .. descStr
      end
      self.text.text = str
      YearMemoryProxy.Instance:CallSetYearMemoryTitleUserCmd(self.version, nil, randomList)
    end
  else
    self.infoBg:SetActive(false)
    self.picBg:SetActive(true)
    self.titlePop:SetActive(false)
    self.editBtn:SetActive(false)
    self.logo1.transform.localPosition = LuaGeometry.GetTempVector3(313, -120, 0)
    self.logo2.transform.localPosition = LuaGeometry.GetTempVector3(212, -113, 0)
    self.title.text = string.format(ZhString.ActivityIntegration_YearMemory, Game.Myself.data:GetName())
    local info = YearMemoryProxy.Instance:GetIndexsByVersionAndPage(self.version, self.page)
    local indexs = info and info.indexes
    if indexs and 0 < #indexs then
      local str = ""
      for i = 1, #indexs do
        local lineInfo = Table_YearMemoryLine[indexs[i]]
        if lineInfo then
          if str ~= "" then
            str = str .. [[


]]
          end
          local descStr = OverSea.LangManager.Instance():GetLangByKey(lineInfo.Desc)
          if YearMemoryProxy.Instance:HasReplaceInfo(self.version, descStr) then
            descStr = YearMemoryProxy.Instance:AdaptReplaceMark(self.version, descStr)
            str = str .. descStr
          else
            local replaceID = lineInfo.ReplaceID
            if replaceID then
              descStr = OverSea.LangManager.Instance():GetLangByKey(Table_YearMemoryLine[replaceID].Desc)
              if YearMemoryProxy.Instance:HasReplaceInfo(self.version, descStr) then
                descStr = YearMemoryProxy.Instance:AdaptReplaceMark(self.version, descStr)
                str = str .. descStr
              else
                descStr = OverSea.LangManager.Instance():GetLangByKey(lineInfo.ReplaceDesc)
                str = str .. descStr
              end
            else
              descStr = OverSea.LangManager.Instance():GetLangByKey(lineInfo.ReplaceDesc)
              str = str .. descStr
            end
          end
        end
      end
      self.text.text = str
    end
    self.textureName = info and info.texture
    if self.textureName and self.textureName ~= "" then
      PictureManager.Instance:SetUI(self.textureName, self.texture)
    end
  end
  self.textScrollView:ResetPosition()
end

function MemoryPageCell:SetScreenShotMode(bool)
  if bool then
    self.editBtn:SetActive(false)
    self.titleArrow:SetActive(false)
    self.title_lockBg:SetActive(true)
    self.title_Bg:SetActive(false)
    self.logo1:SetActive(false)
    self.logo2:SetActive(true)
  else
    if self.isSummary then
      self.editBtn:SetActive(true)
    end
    self.titleArrow:SetActive(true)
    self.title_lockBg:SetActive(false)
    self.title_Bg:SetActive(true)
    self.logo1:SetActive(true)
    self.logo2:SetActive(false)
  end
end

local svTweenParam = {
  [1] = {offsetY = -147, height = 20},
  [2] = {offsetY = -103, height = 350}
}

function MemoryPageCell:PlayEnterTween()
  TimeTickManager.Me():ClearTick(self)
  TimeTickManager.Me():CreateTickFromTo(0, 0, 1, 3500, function(owner, deltaTime, curValue)
    local curPer = curValue
    local clip = self.textPanel.baseClipRegion
    local height_value = (svTweenParam[2].height - svTweenParam[1].height) * curPer
    local targetOffsetY = 72 - height_value / 2
    self.textPanel.clipOffset = LuaGeometry.GetTempVector2(self.textPanel.clipOffset.x, targetOffsetY)
    self.textPanel.baseClipRegion = LuaGeometry.GetTempVector4(clip.x, clip.y, clip.z, height_value)
  end, self, 1)
  local bg1 = self.picBg:GetComponent(UISprite)
  local bg2 = self.infoBg:GetComponent(UISprite)
  bg1.alpha = 0
  bg2.alpha = 0
  TimeTickManager.Me():CreateOnceDelayTick(3500, function(owner, deltaTime)
    TweenAlpha.Begin(self.picBg, 1, 1)
    TweenAlpha.Begin(self.infoBg, 1, 1)
  end, self, 2)
end

function MemoryPageCell:OnCellDestroy()
  PictureManager.Instance:UnLoadUI("anniversarymemories_bg_1", self.bgTexture)
  PictureManager.Instance:UnLoadUI("mall_bg_key", self.key)
  PictureManager.Instance:UnLoadUI("anniversarymemories_bg_qrcode", self.QRCode)
  if self.textureName and self.textureName ~= "" then
    PictureManager.Instance:UnLoadUI(self.textureName, self.texture)
  end
  TimeTickManager.Me():ClearTick(self)
end
