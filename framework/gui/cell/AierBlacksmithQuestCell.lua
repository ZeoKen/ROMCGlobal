local BaseCell = autoImport("BaseCell")
AierBlacksmithQuestCell = class("AierBlacksmithQuestCell", BaseCell)
local tickMgr = TimeTickManager.Me()
local btnTextOutlineColor = {
  blue = LuaColor(0.13333333333333333, 0.23921568627450981, 0.5725490196078431),
  orange = LuaColor(0.5882352941176471, 0.2901960784313726, 0),
  red = LuaColor(0.41568627450980394, 0.03137254901960784, 0.054901960784313725),
  grey = LuaColor(0.5019607843137255, 0.5019607843137255, 0.5019607843137255)
}

function AierBlacksmithQuestCell:Init()
  self:FindObjs()
  self:AddUIEvents()
end

function AierBlacksmithQuestCell:FindObjs()
  self.name = self:FindComponent("ItemName", UILabel)
  self.desc = self:FindComponent("desc", UILabel)
  self.descicon = self:FindComponent("descicon", UISprite)
  self.finishMark = self:FindGO("finishMark")
  self.helpMark = self:FindGO("helpMark")
  self.helpLeftTime = self:FindComponent("helpLeftTime", UILabel)
  self.btn = self:FindGO("ActionButton")
  self.btnColl = self.btn:GetComponent(BoxCollider)
  self.btnSp = self.btn:GetComponent(UIMultiSprite)
  self.btnText = self:FindComponent("Label", UILabel, self.btn)
  self.name.transform.localPosition = LuaVector3(-271, 18, 0)
end

function AierBlacksmithQuestCell:AddUIEvents()
  self:AddClickEvent(self.btn, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function AierBlacksmithQuestCell:SetData(data)
  self.data = data
  self.finishMark:SetActive(false)
  self.helpMark:SetActive(false)
  self.btn:SetActive(false)
  self:ClearTick()
  local questid = data.questid
  local questinfo
  for _, v in pairs(Table_SmithQuest) do
    if v.QuestID == questid then
      questinfo = v
      break
    end
  end
  self.questinfo = questinfo
  if questinfo then
    self.name.text = questinfo.Desc
    local item_id = questinfo.RewardItem[1]
    local num = questinfo.RewardItem[2]
    local item_cfg = Table_Item[item_id]
    UIUtil.TempSetItemIcon(self.descicon, item_cfg.Icon, 50)
    self.desc.text = item_cfg.NameZh .. "X" .. num
  else
    self.name.text = "ERROR"
    self.desc.text = "ERROR"
    return
  end
  local questStatus = data.quest_state
  local inHelp = data.help_partner and data.help_partner > 0 and questStatus ~= ESMITHQUESTSTATE.ESMITH_QUEST_DONE
  if inHelp then
    self.helpMark:SetActive(true)
    self.timeTick = tickMgr:CreateTick(0, 33, self.UpdateDuration, self, 1)
  end
  UIUtil.TempSetButtonStyle(1, self.btn)
  if questStatus == ESMITHQUESTSTATE.ESMITH_QUEST_ACCEPTED then
    local questData = QuestProxy.Instance:GetQuestDataBySameQuestID(questid)
    if not questData then
      self.btn:SetActive(false)
    else
      self.btn:SetActive(true)
      if questData.staticData and questData.staticData.Params and questData.staticData.Params.ifAccessFc then
        self.btnText.text = ZhString.AierBlacksmithBtn_Submit
        UIUtil.TempSetButtonStyle(4, self.btn)
      else
        self.btnText.text = ZhString.AierBlacksmithBtn_GiveUp
        UIUtil.TempSetButtonStyle(3, self.btn)
      end
    end
  elseif questStatus == ESMITHQUESTSTATE.ESMITH_QUEST_HELPED then
    self.helpMark:SetActive(true)
  elseif questStatus == ESMITHQUESTSTATE.ESMITH_QUEST_DONE then
    self.finishMark:SetActive(true)
  else
    self.btn:SetActive(true)
    self.btnText.text = ZhString.AierBlacksmithBtn_Accept
  end
end

function AierBlacksmithQuestCell:UpdateDuration()
  self.endTime = self.data and self.data.help_finish_time
  if self.endTime > 0 then
    local leftTime = math.max(self.endTime - ServerTime.CurServerTime() / 1000, 0)
    self.helpLeftTime.text = string.format(ZhString.AierBlacksmithHelpLeftTime, leftTime)
    if leftTime <= 0 then
      self.data.help_finish_time = -1
      tickMgr:CreateOnceDelayTick(1000, function(owner, deltaTime)
        AierBlacksmithTestMe.Me():CallSmithInfoManorCmd()
      end, self)
    end
    self.helpMark:SetActive(true)
  else
    self:ClearTick()
    self.helpMark:SetActive(false)
  end
end

function AierBlacksmithQuestCell:ClearTick()
  if self.timeTick ~= nil then
    tickMgr:ClearTick(self)
    self.timeTick = nil
  end
end

function AierBlacksmithQuestCell:OnCellDestroy()
  self:ClearTick()
end
