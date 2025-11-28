local BaseCell = autoImport("BaseCell")
MapBoardQuestFatherCell = class("MapBoardQuestFatherCell", BaseCell)

function MapBoardQuestFatherCell:Init()
  self.label = self:FindComponent("Label", UILabel)
  self.TitleIcon = self:FindGO("QuestTypeIcon")
  self.TitleIcon_UISprite = self.TitleIcon:GetComponent(UISprite)
  self:AddCellClickEvent()
end

function MapBoardQuestFatherCell:SetData(data)
  self.data = data
  self.ColorFromServer = self.data.ColorFromServer
  if self.ColorFromServer then
    if GameConfig.Quest.QuestSort[self.ColorFromServer] then
      self.label.text = GameConfig.Quest.QuestSort[self.ColorFromServer].name
      if self.ColorFromServer == 20 then
        local curProcess = QuestProxy.Instance:GetWorldQuestProcess()
        if curProcess and 4 < curProcess then
          curProcess = 4
        end
        self.label.text = self.label.text .. "(" .. curProcess .. "/4)"
      end
    else
      redlog("GameConfig.Quest.QuestSort缺少ID为" .. self.ColorFromServer .. "的配置")
    end
  end
  if GameConfig and GameConfig.Quest and GameConfig.Quest.TraceIcon and GameConfig.Quest.TraceIcon[self.ColorFromServer] then
    local atlasStr = GameConfig.Quest.TraceIcon[self.ColorFromServer][2]
    local spriteNameStr = GameConfig.Quest.TraceIcon[self.ColorFromServer][1]
    local iconScale = GameConfig.Quest.TraceIcon[self.ColorFromServer][3] * 1.3
    local needMakePixelPerfect = GameConfig.Quest.TraceIcon[self.ColorFromServer][4]
    if atlasStr and spriteNameStr then
      if IconManager:SetIconByType(spriteNameStr, self.TitleIcon_UISprite, atlasStr) then
        self:Show(self.TitleIcon)
        if needMakePixelPerfect then
          self.TitleIcon_UISprite:MakePixelPerfect()
        end
        if iconScale then
          self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
        elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
          self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
        end
        return
      end
      local ui1Atlas = RO.AtlasMap.GetAtlas(atlasStr)
      if ui1Atlas == nil then
        helplog("请任务追踪框策划确认 没有图集！" .. atlasStr)
        self:Hide(self.TitleIcon)
        return
      end
      self.TitleIcon_UISprite.atlas = ui1Atlas
      self.TitleIcon_UISprite.spriteName = spriteNameStr
      self:Show(self.TitleIcon)
      if needMakePixelPerfect then
        self.TitleIcon_UISprite:MakePixelPerfect()
      end
      if iconScale then
        self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(iconScale, iconScale, iconScale)
      elseif GameConfig and GameConfig.Quest and GameConfig.Quest.TitleIconScale then
        self.TitleIcon.gameObject.transform.localScale = LuaGeometry.GetTempVector3(GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale, GameConfig.Quest.TitleIconScale)
      end
      return
    else
    end
  else
  end
end
