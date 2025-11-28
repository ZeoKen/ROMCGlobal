local baseCell = autoImport("BaseCell")
ActivityGoalListCell = class("ActivityGoalListCell", baseCell)

function ActivityGoalListCell:Init()
  self:initView()
end

local greyOutline = Color(0.8470588235294118, 0.8470588235294118, 0.8470588235294118)
local greyColor = Color(0.4666666666666667, 0.4666666666666667, 0.4823529411764706)
local greenOutline = Color(0.8549019607843137, 0.9725490196078431, 0.9372549019607843)
local greenColor = Color(0.19215686274509805, 0.5411764705882353, 0.043137254901960784)
local ScaleV = LuaVector3.New(0.6, 0.6, 1)

function ActivityGoalListCell:initView()
  self.icon = self:FindGO("Icon"):GetComponent(UISprite)
  self:AddButtonEvent("IconBack", function()
    local cell = {}
    if self.data and self.data.RewardID then
      local rewardCfg = ItemUtil.GetRewardItemIdsByTeamId(self.data.RewardID)
      rewardCfg = rewardCfg and rewardCfg[1]
      if rewardCfg then
        cell.data = ItemData.new("", rewardCfg.id)
        cell.data:SetItemNum(rewardCfg.num)
      end
    end
    self:PassEvent(ActivityPuzzleGoEvent.ClickIconTip, cell)
  end)
  self.goalName = self:FindComponent("GoalName", UILabel)
  self.goalProgress = self:FindComponent("GoalProgress", UILabel)
  self.lightUpAlreaday = self:FindComponent("LightUpAlreaday", UILabel)
  self.lightButton = self:FindGO("LightButton")
  self:AddButtonEvent("LightButton", function()
    if ActivityPuzzleProxy.Instance:CheckUpdateRedtip(self.data.ActivityID) then
      ServiceSceneTipProxy.Instance:CallBrowseRedTipCmd(SceneTip_pb.EREDSYS_PUZZLE, self.data.ActivityID)
    end
    ServicePuzzleCmdProxy.Instance:CallActivePuzzleCmd(self.data.ActivityID, self.data.PuzzleID)
  end)
  self.goButton = self:FindGO("GOButton")
  self:AddButtonEvent("GOButton", function()
    if self.data.GotoMode ~= _EmptyTable then
      self:PassEvent(ActivityPuzzleGoEvent.MouseClick, self)
    end
  end)
  self.lock = self:FindGO("Lock")
  self.durationLabel = self:FindGO("durationLabel"):GetComponent(UILabel)
  self.ongoing = self:FindGO("Ongoing")
  self:AddCellClickEvent()
  self.extra = self:FindGO("extra")
end

function ActivityGoalListCell:SetData(data)
  self.data = data
  self.goalName.text = data.Desc
  if data.Icon == "" or not IconManager:SetIconByType(data.Icon, self.icon, self.data.Atlas, "uiicon") then
    IconManager:SetItemIcon("item_45001", self.icon)
  end
  self.icon:MakePixelPerfect()
  self.icon.transform.localScale = ScaleV
  local itemData = ActivityPuzzleProxy.Instance:GetActivityPuzzleItemData(data.ActivityID, data.PuzzleID)
  local trim = 0
  local goStarttime, goEndtime = ActivityPuzzleProxy.Instance:GetPuzzleItemDate(data)
  if itemData then
    if data.UnlockTime then
      if itemData.process then
        trim = itemData.process > data.UnlockTime and data.UnlockTime or itemData.process
        self.goalProgress.text = trim .. "/" .. data.UnlockTime
      else
        self.goalProgress.text = "0/" .. data.UnlockTime
      end
    else
      self.goalProgress.text = ""
    end
    if data.locked == 1 then
      local dataFormat = OverSea.LangManager.Instance():GetLangByKey(ZhString.DoujinshiButton_ActivityPuzzleTime)
      self.durationLabel.text = os.date(dataFormat, goStarttime) .. "-" .. os.date(dataFormat, goEndtime)
    elseif data.locked == 2 then
      self.durationLabel.text = ZhString.ActivityPuzzle_Outtime
    elseif data.locked == 3 and not self.timeTick then
      self.timeTick = TimeTickManager.Me():CreateTick(0, 1000, self.UpdateCountDown, self, 11)
    end
    if data.locked and data.locked == 1 then
      self.lock:SetActive(true)
      self.goButton:SetActive(false)
      self.lightButton:SetActive(false)
      self.lightUpAlreaday.gameObject:SetActive(false)
    else
      self.lock:SetActive(false)
      if itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_CANACTIVE then
        self.lightButton:SetActive(true)
        self.lightUpAlreaday.gameObject:SetActive(false)
        self.goButton:SetActive(false)
      elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_UNACTIVE then
        self.goButton:SetActive(data.locked and data.locked == 3)
        self.lightButton:SetActive(false)
        self.lightUpAlreaday.gameObject:SetActive(data.locked and data.locked == 2)
        if data.locked and data.locked == 2 then
          self:SetOuttime()
        end
        if self.data.GotoMode == nil or self.data.GotoMode == _EmptyTable then
          self.goButton:SetActive(false)
          self.lightUpAlreaday.gameObject:SetActive(data.locked and data.locked == 3)
          self:SetOngoing()
        end
      elseif itemData.PuzzleState == PuzzleCmd_pb.EPUZZLESTATE_ACTIVE then
        self.goButton:SetActive(false)
        self.lightButton:SetActive(false)
        self.lightUpAlreaday.gameObject:SetActive(true)
        self:SetComplete()
      else
        self.goButton:SetActive(data.locked and data.locked == 3)
        self.lightButton:SetActive(false)
        self.lightUpAlreaday.gameObject:SetActive(data.locked and data.locked == 2)
        if data.locked and data.locked == 2 then
          self:SetOuttime()
        end
        if self.data.GotoMode == nil or self.data.GotoMode == _EmptyTable then
          self.goButton:SetActive(false)
          self.lightUpAlreaday.gameObject:SetActive(data.locked and data.locked == 3)
          self:SetOngoing()
        end
      end
    end
  else
    self.goButton:SetActive(false)
    self.lightButton:SetActive(false)
    self.lightUpAlreaday.gameObject:SetActive(false)
    self.goalProgress.text = "0/" .. data.UnlockTime
  end
  if data.GoCondition then
    local cons = data.GoCondition
    for i = 1, #cons do
      local pdata = ActivityPuzzleProxy.Instance:GetActivityPuzzleItemData(self.data.ActivityID, cons[i])
      if pdata and not pdata:IsUnlock() then
        self.goButton:SetActive(false)
        break
      end
    end
  end
  self.extra:SetActive(data.UnlockType == 8)
end

function ActivityGoalListCell:SetComplete()
  self.lightUpAlreaday.text = ZhString.ActivityPuzzle_Complete
  self.lightUpAlreaday.effectColor = greyOutline
  self.lightUpAlreaday.effectStyle = UILabel.Effect.Outline
  self.lightUpAlreaday.color = greyColor
end

function ActivityGoalListCell:SetOngoing()
  self.lightUpAlreaday.text = ZhString.ActivityPuzzle_Ongoin
  self.lightUpAlreaday.effectColor = greenOutline
  self.lightUpAlreaday.effectStyle = UILabel.Effect.Outline
  self.lightUpAlreaday.color = greenColor
end

function ActivityGoalListCell:SetOuttime()
  self.lightUpAlreaday.text = ZhString.ActivityPuzzle_Outtime
  self.lightUpAlreaday.effectColor = greyOutline
  self.lightUpAlreaday.effectStyle = UILabel.Effect.Outline
  self.lightUpAlreaday.color = greyColor
end

local day, hour, min, sec
local DAY_SECOND = 86400

function ActivityGoalListCell:UpdateCountDown()
  local lefttime = self.data.goEndtime - ServerTime.CurServerTime() / 1000
  if 0 < lefttime then
    day, hour, min = ClientTimeUtil.FormatTimeBySec(lefttime)
  else
    if self.timeTick then
      TimeTickManager.Me():ClearTick(self)
      self.timeTick = nil
    end
    local dataFormat = OverSea.LangManager.Instance():GetLangByKey(ZhString.DoujinshiButton_ActivityPuzzleTime)
    self.durationLabel.text = os.date(dataFormat, self.data.goStarttime) .. "-" .. os.date(dataFormat, self.data.goEndtime)
  end
  min = min ~= 0 and min or 1
  if lefttime >= DAY_SECOND then
    self.durationLabel.text = string.format(ZhString.ActivityPuzzle_LefttimeInDays, day)
  else
    self.durationLabel.text = string.format(ZhString.ActivityPuzzle_LefttimeInHours, hour, min)
  end
end

function ActivityGoalListCell:ClearTick()
  if self.timeTick then
    TimeTickManager.Me():ClearTick(self)
    self.timeTick = nil
  end
end
