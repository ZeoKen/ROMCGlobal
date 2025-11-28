DesertWolfJoinView = class("DesertWolfJoinView", ContainerView)
DesertWolfJoinView.ViewType = UIViewType.PopUpLayer

function DesertWolfJoinView:Init()
  self:FindObjs()
  self:AddEvts()
  self:AddViewEvts()
  self:InitShow()
end

function DesertWolfJoinView:FindObjs()
  self.nameInput = self:FindGO("NameInput"):GetComponent(UIInput)
  UIUtil.LimitInputCharacter(self.nameInput, 12)
end

function DesertWolfJoinView:AddEvts()
  local joinButton = self:FindGO("JoinButton", self.desertWolfView)
  self:AddClickEvent(joinButton, function()
    self:ClickJoin()
  end)
end

function DesertWolfJoinView:AddViewEvts()
end

function DesertWolfJoinView:InitShow()
  self.defaultName = string.format(OverSea.LangManager.Instance():GetLangByKey(ZhString.Pvp_DesertWolfJoinName), Game.Myself.data:GetName())
  self.nameInput.value = self.defaultName
end

function DesertWolfJoinView:ClickJoin()
  if not TeamProxy.Instance:CheckDiffServerValidByPvpType(PvpProxy.Type.DesertWolf) then
    MsgManager.ShowMsgByID(42042)
    return
  end
  local resultStr = string.gsub(self.nameInput.value, " ", "")
  if StringUtil.ChLength(resultStr) >= 2 then
    if not FunctionMaskWord.Me():CheckMaskWord(resultStr, GameConfig.MaskWord.PvpName) then
      ServiceMatchCCmdProxy.Instance:CallJoinRoomCCmd(PvpProxy.Type.DesertWolf, 0, resultStr)
      self:CloseSelf()
    else
      MsgManager.ShowMsgByIDTable(958)
    end
  else
    MsgManager.ShowMsgByIDTable(883)
  end
end
