EndlessBattleFieldResultCell = class("EndlessBattleFieldResultCell", BaseCell)
local humanBgCol = "9fcbff"
local vampireBgCol = "ffafaf"

function EndlessBattleFieldResultCell:Init()
  self:FindObjs()
end

function EndlessBattleFieldResultCell:FindObjs()
  self.bg = self:FindComponent("Bg", UISprite)
  self.icon = self:FindComponent("Career", UISprite)
  self.nameLabel = self:FindComponent("Data", UILabel)
end

function EndlessBattleFieldResultCell:SetData(data)
  self.data = data
  if data then
    self.nameLabel.text = data.username
    local proConfig = Table_Class[data.profession]
    IconManager:SetProfessionIcon(proConfig and proConfig.icon, self.icon)
    local camp = data.camp
    local colStr = camp == FuBenCmd_pb.ETEAMPWS_RED and humanBgCol or vampireBgCol
    local _, c = ColorUtil.TryParseHexString(colStr)
    self.bg.color = c
  end
end
