autoImport("BaseCell")
PostcardStyleSelectCell = class("PostcardStyleSelectCell", BaseCell)

function PostcardStyleSelectCell:Init()
  self:FindObjs()
  self:AddCellClickEvent()
end

function PostcardStyleSelectCell:FindObjs()
  self.nameLb = self:FindComponent("name", UILabel)
  self.iconSp = self:FindComponent("icon", UISprite)
  self.selectMark = self:FindGO("select")
end

function PostcardStyleSelectCell:SetData(data)
  self.data = data
  if not self:CheckDateValid(data.ShowTime) then
    self:Hide()
    return
  end
  self:Show()
  self.nameLb.text = data.Name
  if data.Icon then
    if not IconManager:SetUIIcon(data.Icon, self.iconSp) and not IconManager:SetItemIcon(data.Icon, self.iconSp) then
      IconManager:SetItemIcon("item_45001", self.iconSp)
    end
    UIUtil.TempLimitIconSize(self.iconSp, 60, 60)
  end
end

function PostcardStyleSelectCell:SetSelected(selected)
  self.selectMark:SetActive(selected == true)
end

function PostcardStyleSelectCell:CheckDateValid(StartDate)
  if StartDate == nil or StartDate == "" then
    return true
  end
  local customStartData = self:GetSelfCustomDate(StartDate)
  local curServerTime = ServerTime.CurServerTime()
  if customStartData > curServerTime / 1000 then
    return false
  end
  return true
end

function PostcardStyleSelectCell:GetSelfCustomDate(validDate)
  local p = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)"
  local year, month, day, hour, min, sec = validDate:match(p)
  if day == nil then
    helplog("策划瞎写")
    return
  end
  local startDate = os.time({
    day = day,
    month = month,
    year = year,
    hour = hour,
    min = min,
    sec = sec
  })
  return startDate
end
