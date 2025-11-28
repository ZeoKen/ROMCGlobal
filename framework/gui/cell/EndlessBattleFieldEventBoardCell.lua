autoImport("EndlessBattleCellModule")
local eventNameFormat = "[u]%s[/u]"
local ArrayPushBack = TableUtility.ArrayPushBack
EndlessBattleFieldEventBoardCell = class("EndlessBattleFieldEventBoardCell", BaseCell)
local EventProgressTypeCell = {
  occupy = {
    prefab = "EBFEventProgressType_OccupyCell",
    class = EBFProgressOccupyTypeCell
  },
  coin = {
    prefab = "EBFEventProgressTypeCell",
    class = EBFProgressCoinTypeCell
  },
  kill_monster = {
    prefab = "EBFEventProgressTypeCell",
    class = EBFProgressKillMonsterTypeCell
  },
  statue = {
    prefab = "EBFEventProgressTypeCell",
    class = EBFProgressStatueTypeCell
  },
  kill_boss = {
    prefab = "EBFEventProgressType_KillBossCell",
    class = EBFProgressKillBossTypeCell
  },
  escort = {
    prefab = "EBFEventProgressType_EscortCell",
    class = EBFProgressEscortTypeCell
  }
}
local WinnerCol = {
  [FuBenCmd_pb.ETEAMPWS_RED] = "9fb6ff",
  [FuBenCmd_pb.ETEAMPWS_BLUE] = "ff7575",
  [FuBenCmd_pb.ETEAMPWS_MIN] = "9d9d9d"
}

function EndlessBattleFieldEventBoardCell:Init()
  self:FindObjs()
end

function EndlessBattleFieldEventBoardCell:AddAlphaList(widget)
  ArrayPushBack(self.alphaTodo, widget)
end

function EndlessBattleFieldEventBoardCell:GrayAlpha(var)
  local value = var and 0.5 or 1
  for _, v in pairs(self.alphaTodo) do
    v.alpha = value
  end
end

function EndlessBattleFieldEventBoardCell:FindObjs()
  self.alphaTodo = {}
  self.nameLabel = self:FindComponent("Name", UILabel)
  self:AddAlphaList(self.nameLabel)
  self.unstartNameLabel = self:FindComponent("UnstartName", UILabel)
  self.indexLabel = self:FindComponent("Index", UILabel)
  self:AddAlphaList(self.indexLabel)
  self.eventIcon = self:FindComponent("Icon", UISprite)
  self:AddAlphaList(self.eventIcon)
  self.winnerLabel = self:FindComponent("Winner", UILabel)
  self:AddAlphaList(self.winnerLabel)
  self.stateLabel = self:FindComponent("State", UILabel)
  self.progressContainer = self:FindGO("ProgressContainer")
  self.containerWidget = self.progressContainer:GetComponent(UIWidget)
  self:AddAlphaList(self.containerWidget)
  self.line = self:FindGO("line")
  self:AddCellClickEvent()
end

function EndlessBattleFieldEventBoardCell:SetData(data)
  self.data = data
  if data then
    self.indexLabel.text = data.index
    local eventData = data.eventData
    self:SetState(eventData ~= nil)
    self.line:SetActive(data.index ~= EndlessBattleFieldEventBoard.MAXCOUNT)
    if eventData then
      local staticData = eventData.staticData
      if staticData then
        local type = staticData.Type
        if not self.progressCell then
          self:CreateProgressCell(type)
        elseif self.cellType ~= type then
          self:RecreateProgressCell(type)
        end
        self.cellType = type
        if self.progressCell then
          self.progressCell:SetData(eventData)
        end
        self.nameLabel.text = string.format(eventNameFormat, staticData.Name)
        self.eventIcon.spriteName = staticData.Icon
        local winnerStr = ""
        local winner = eventData.winner or 0
        if not eventData.isEnd then
          winnerStr = ZhString.EndlessBattleEvent_InBattle
        elseif winner == FuBenCmd_pb.ETEAMPWS_RED then
          winnerStr = ZhString.EndlessBattleEvent_HumanWin_Short
        elseif winner == FuBenCmd_pb.ETEAMPWS_BLUE then
          winnerStr = ZhString.EndlessBattleEvent_VampireWin_Short
        else
          winnerStr = ZhString.EndlessBattleEvent_Draw
        end
        self.winnerLabel.text = winnerStr
        local _, c = ColorUtil.TryParseHexString(WinnerCol[winner])
        self.winnerLabel.color = c
        self:GrayAlpha(eventData.isEnd)
      end
      ColorUtil.WhiteUIWidget(self.indexLabel)
    else
      if data.index == EndlessBattleFieldEventBoard.MAXCOUNT then
        local id = GameConfig.EndlessBattleField and GameConfig.EndlessBattleField.Final
        local config = Table_EndlessBattleFieldEvent[id]
        if config then
          self.unstartNameLabel.text = config.Name
          self.eventIcon.spriteName = config.Icon
        end
        LuaGameObject.SetLocalPositionGO(self.unstartNameLabel.gameObject, -153, 0, 0)
      else
        if data.nextEventId and 0 < data.nextEventId then
          local config = Table_EndlessBattleFieldEvent[data.nextEventId]
          self.unstartNameLabel.text = config and config.Name or ""
        else
          self.unstartNameLabel.text = ZhString.EndlessBattleEvent_RandomEvent
        end
        LuaGameObject.SetLocalPositionGO(self.unstartNameLabel.gameObject, -191, 0, 0)
      end
      if data.countdown then
        self.stateLabel.text = string.format(ZhString.EndlessBattleEvent_StartTime, data.countdown)
      else
        self.stateLabel.text = ZhString.EndlessBattleEvent_WaitForStart
      end
      local _, c = ColorUtil.TryParseHexString(WinnerCol[FuBenCmd_pb.ETEAMPWS_MIN])
      self.indexLabel.color = c
    end
  end
end

function EndlessBattleFieldEventBoardCell:SetState(state)
  self.nameLabel.gameObject:SetActive(state)
  self.unstartNameLabel.gameObject:SetActive(not state)
  self.eventIcon.gameObject:SetActive(state or self.data.index == EndlessBattleFieldEventBoard.MAXCOUNT)
  self.winnerLabel.gameObject:SetActive(state)
  self.stateLabel.gameObject:SetActive(not state)
  self.progressContainer:SetActive(state)
end

function EndlessBattleFieldEventBoardCell:OnCellDestroy()
  self:DestroyProgressCell()
end

function EndlessBattleFieldEventBoardCell:CreateProgressCell(type)
  local cellClass = EventProgressTypeCell[type].class
  if cellClass then
    self.progressCell = cellClass.new(EventProgressTypeCell[type].prefab, self.progressContainer)
  end
end

function EndlessBattleFieldEventBoardCell:DestroyProgressCell()
  if self.progressCell then
    if self.progressCell.OnCellDestroy and type(self.progressCell.OnCellDestroy) == "function" then
      self.progressCell:OnCellDestroy()
    end
    GameObject.DestroyImmediate(self.progressCell.gameObject)
    self.progressCell = nil
  end
end

function EndlessBattleFieldEventBoardCell:RecreateProgressCell(type)
  self:DestroyProgressCell()
  self:CreateProgressCell(type)
end
