EndlessBattleFieldEventOverviewCell = class("EndlessBattleFieldEventOverviewCell", BaseCell)
local HumanCol = "[c][9fb6ff]"
local VampireCol = "[c][ff7575]"
local HumanWinSp = "battlefield_star_2"
local vampireWinSp = "battlefield_star_1"

function EndlessBattleFieldEventOverviewCell:Init()
  self:FindObjs()
end

function EndlessBattleFieldEventOverviewCell:FindObjs()
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.icon = self:FindComponent("Icon", UISprite)
  self.nameLabel = self:FindComponent("Name", UILabel)
  self.scoreLabel = self:FindComponent("Score", UILabel)
  self.winnerSp = self:FindComponent("Winner", UISprite)
  self.drawGO = self:FindGO("Draw")
end

function EndlessBattleFieldEventOverviewCell:SetData(data)
  self.data = data
  if data then
    local staticData = data.staticData
    if staticData then
      self.nameLabel.text = staticData.Name
      self.icon.spriteName = staticData.Icon
    end
    if staticData.Type == "escort" then
      local total = (data.humanScore + data.vampireScore) * 0.5
      local humanRatio = 0 < total and (total - data.humanScore) / total or 0
      local vampireRatio = 0 < total and (total - data.vampireScore) / total or 0
      local humanFormatPrefix = ""
      if 0 < humanRatio then
        humanFormatPrefix = "+"
      elseif humanRatio < 0 then
        humanFormatPrefix = "-"
      end
      local vampireFormatPrefix = ""
      if 0 < vampireRatio then
        vampireFormatPrefix = "+"
      elseif vampireRatio < 0 then
        vampireFormatPrefix = "-"
      end
      local str = HumanCol .. humanFormatPrefix .. "%d%%[-][/c]:" .. VampireCol .. vampireFormatPrefix .. "%d%%[-][/c]"
      self.scoreLabel.text = string.format(str, humanRatio * 100, vampireRatio * 100)
    elseif staticData.Type == "kill_boss" then
      local monster = staticData.Misc.monster_id
      if Table_Monster[monster] then
        local total = Table_Monster[monster].Hp
        if total then
          local humanRatio = data.humanScore / total
          local vampireRatio = data.vampireScore / total
          self.scoreLabel.text = string.format(HumanCol .. "%d%%[-][/c]:" .. VampireCol .. "%d%%[-][/c]", humanRatio * 100, vampireRatio * 100)
        end
      end
    else
      self.scoreLabel.text = string.format(HumanCol .. "%d[-][/c]:" .. VampireCol .. "%d[-][/c]", data.humanScore, data.vampireScore)
    end
    if data.isEnd then
      local winner = data.winner
      if winner ~= FuBenCmd_pb.ETEAMPWS_MIN then
        local sp = winner == FuBenCmd_pb.ETEAMPWS_RED and HumanWinSp or vampireWinSp
        self.winnerSp.spriteName = sp
      end
      self.drawGO:SetActive(winner == FuBenCmd_pb.ETEAMPWS_MIN)
    else
      self.drawGO:SetActive(false)
    end
    self:SetState(not data.isEnd)
  end
end

function EndlessBattleFieldEventOverviewCell:SetState(state)
  self.scoreLabel.gameObject:SetActive(state)
  self.winnerSp.gameObject:SetActive(not state)
  self.widget.alpha = state and 1 or 0.5
end
