autoImport("ItemData")
local baseCell = autoImport("BaseCell")
ChatRoomSystemCell = reusableClass("ChatRoomSystemCell", baseCell)
ChatRoomSystemCell.PoolSize = 60
ChatRoomSystemCell.rid = ResourcePathHelper.UICell("ChatRoomSystemCell")

function ChatRoomSystemCell:Construct(asArray, args)
  self._alive = true
  self:DoConstruct(asArray, args)
end

function ChatRoomSystemCell:Deconstruct()
  self._alive = false
  self.data = nil
  Game.GOLuaPoolManager:AddToChatPool(self.gameObject)
end

function ChatRoomSystemCell:Alive()
  return self._alive
end

function ChatRoomSystemCell:DoConstruct(asArray, args)
  self.parent = args
  if self.gameObject == nil then
    self:CreateSelf(self.parent)
    self:FindObjs()
  else
    self.gameObject = Game.GOLuaPoolManager:GetFromChatPool(self.gameObject, self.parent)
  end
end

function ChatRoomSystemCell:Finalize()
  ChatRoomSystemCell.super.ClearEvent(self)
  GameObject.Destroy(self.gameObject)
end

function ChatRoomSystemCell:ClearEvent()
end

function ChatRoomSystemCell:CreateSelf(parent)
  if parent then
    self.gameObject = self:CreateObj(ChatRoomSystemCell.rid, parent)
  end
end

function ChatRoomSystemCell:FindObjs()
  self.SystemMessage = self.gameObject:GetComponent(UILabel)
  self.top = self:FindGO("Top"):GetComponent(UIWidget)
  self.clickUrl = self.gameObject:GetComponent(UILabelClickUrl)
  if self.clickUrl then
    function self.clickUrl.callback(url)
      self:OnClickUrl(url)
    end
  end
end

local itemTipData = {
  funcConfig = {}
}
local tipOffset = {240, -80}
local funkey = {
  "InviteMember",
  "SendMessage",
  "AddFriend",
  "ShowDetail",
  "AddBlacklist",
  "InviteEnterGuild",
  "Tutor_InviteBeTutor",
  "Tutor_InviteBeStudent",
  "EnterHomeRoom"
}

function ChatRoomSystemCell:OnClickUrl(url)
  local split = string.split(url, ChatRoomProxy.ItemCodeSymbol)
  local urlType = split[1]
  if urlType == "configitem" then
    local itemId = split[2]
    if type(itemId) == "string" then
      itemId = tonumber(itemId)
    end
    if not self.tipItemData then
      self.tipItemData = ItemData.new("ChatRoomSystemCell", itemId)
    else
      self.tipItemData:ResetData("ChatRoomSystemCell", itemId)
    end
    itemTipData.itemdata = self.tipItemData
    self:ShowItemTip(itemTipData, self.SystemMessage, NGUIUtil.AnchorSide.Right, tipOffset)
  elseif urlType == "skillcost" then
    local splen = #split
    local goods = {
      id = itemid,
      neednum = num
    }
    for i = 1, splen // 2 do
      local d = {
        id = tonumber(split[i * 2] or "") or 0,
        neednum = tonumber(split[i * 2 + 1] or "") or 0
      }
      table.insert(goods, d)
    end
    GameFacade.Instance:sendNotification(UIEvent.JumpPanel, {
      view = PanelConfig.QuickBuyCountChoosePopUp,
      viewdata = {goods = goods}
    })
  elseif urlType == "datebattle" then
    local dateid = tonumber(split[2])
    if dateid then
      GuildDateBattleProxy.Instance:QueryBattleInfo(dateid)
    end
  elseif urlType == "achievereward" then
    local groupid = tonumber(split[2])
    local shortCutPowerID = GameConfig.NpcAchieve and GameConfig.NpcAchieve[groupid]
    if shortCutPowerID then
      FuncShortCutFunc.Me():CallByID(shortCutPowerID)
    end
  elseif url == "playername" then
    local playerData = PlayerTipData.new()
    local data = self.data:GetSysMsgUserInfo()
    playerData:SetBySysMsgUserInfoData(data)
    FunctionPlayerTip.Me():CloseTip()
    local tipData = {}
    local playerTip = FunctionPlayerTip.Me():GetPlayerTip(self.SystemMessage, NGUIUtil.AnchorSide.Right, {10, 60})
    tipData.playerData = playerData
    tipData.funckeys = funkey
    playerTip:SetData(tipData)
  end
end

local contents

function ChatRoomSystemCell:SetData(data)
  self.data = data
  self.gameObject:SetActive(data ~= nil)
  if data ~= nil then
    self.SystemMessage.alignment = data.alignment and data.alignment or 1
    local text = OverSea.LangManager.Instance():GetLangByKey(OverseaHostHelper:FilterLangStr(data:GetStr()))
    local color = ChatRoomProxy.Instance.channelColor[data:GetChannel()]
    if color then
      contents = color .. text .. "[-]\n"
    else
      contents = text .. "\n"
    end
    self.SystemMessage.text = contents
  end
end
