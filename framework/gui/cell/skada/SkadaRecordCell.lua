SkadaRecordCell = class("SkadaRecordCell", BaseCell)
SkadaRecordCell.ClickDetail = "SkadaRecordCell_ClickDetail"

function SkadaRecordCell:Init()
  SkadaRecordCell.super.Init(self)
  self:FindObjs()
  self:AddEvts()
end

function SkadaRecordCell:FindObjs()
  self.labName = self:FindComponent("Name", UILabel)
  self.sprSex = self:FindComponent("sprSex", UISprite)
  self.labLvJob = self:FindComponent("labLvJob", UILabel)
  self.labFightTime = self:FindComponent("labFightTime", UILabel)
  self.labFightDamage = self:FindComponent("labFightDamage", UILabel)
  self.labDPS = self:FindComponent("labDPS", UILabel)
  self.widgetTipPos = self:FindComponent("widgetTipPos", UIWidget)
  self.serverGO = self:FindGO("Server")
  self.serverLabel = self.serverGO:GetComponent(UILabel)
end

function SkadaRecordCell:AddEvts()
  self:AddCellClickEvent()
  self:AddClickEvent(self:FindGO("btnDetail"), function()
    self:PassEvent(SkadaRecordCell.ClickDetail, self)
  end)
end

function SkadaRecordCell:SetData(data)
  self.data = data
  local haveData = data ~= nil
  if self.isActive ~= haveData then
    self.gameObject:SetActive(haveData)
    self.isActive = haveData
  end
  if not haveData then
    return
  end
  self.labName.text = data.name
  self.sprSex.spriteName = data.gender == ProtoCommon_pb.EGENDER_MALE and "friend_icon_man" or "friend_icon_woman"
  local proData = Table_Class[data.profession] or Table_Class[1]
  self.labLvJob.text = string.format("[4059a8]Lv.%d[-] [818181]%s[-]", data.baselevel or 0, ProfessionProxy.GetProfessionName(proData.id, data.gender))
  local hour, min, sec = ClientTimeUtil.GetHourMinSec(data.totalTime)
  local sb = LuaStringBuilder.CreateAsTable()
  local haveContent = false
  if 0 < hour then
    sb:Append(hour)
    sb:Append("h")
    haveContent = true
  end
  if 0 < min then
    if haveContent then
      sb:Append(" ")
    end
    sb:Append(min)
    sb:Append("min")
    haveContent = true
  end
  if 0 < sec or not haveContent then
    if haveContent then
      sb:Append(" ")
    end
    sb:Append(sec)
    sb:Append("s")
  end
  self.labFightTime.text = sb:ToString()
  sb:Destroy()
  if data.totalDamage < 10000 then
    self.labFightDamage.text = string.format("%.1f", data.totalDamage)
  else
    local millionNum = math.modf(data.totalDamage / 1000000)
    local thousandStr = string.format("%.1f", math.fmod(data.totalDamage, 1000000) / 1000) .. "K"
    self.labFightDamage.text = 0 < millionNum and millionNum .. "M" .. thousandStr or thousandStr
  end
  if 10000 > data.averageDamage then
    self.labDPS.text = string.format("%.1f", data.averageDamage)
  else
    local millionNum = math.modf(data.averageDamage / 1000000)
    local thousandStr = string.format("%.1f", math.fmod(data.averageDamage, 1000000) / 1000) .. "K"
    self.labDPS.text = 0 < millionNum and millionNum .. "M" .. thousandStr or thousandStr
  end
  if data.serverid and data.serverid ~= 0 and data.serverid ~= MyselfProxy.Instance:GetServerId() then
    self.serverGO:SetActive(true)
    self.serverLabel.text = data.serverid
  else
    self.serverGO:SetActive(false)
  end
end
