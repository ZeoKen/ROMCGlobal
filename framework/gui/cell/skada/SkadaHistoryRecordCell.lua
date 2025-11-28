SkadaHistoryRecordCell = class("SkadaHistoryRecordCell", BaseCell)

function SkadaHistoryRecordCell:Init()
  self.headData = HeadImageData.new()
  self:FindObjs()
  self:AddListenEvt()
end

function SkadaHistoryRecordCell:FindObjs()
  if not self.gameObject then
    return
  end
  self.objHeadRoot = self:FindGO("PlayerInfo", singleRankRoot)
  self.objEmpty = self:FindGO("Empty", singleRankRoot)
  self.labPlayerName = self:FindComponent("labPlayerName", UILabel, self.objHeadRoot)
  self.labDPS = self:FindComponent("labDPS", UILabel, self.objHeadRoot)
  self.objProfession = self:FindGO("profession", self.objHeadRoot)
  self.sprProfessionIcon = self:FindComponent("Icon", UISprite, self.objProfession)
  self.sprProfessionColor = self:FindComponent("Color", UISprite, self.objProfession)
  self.headIcon = HeadIconCell.new()
  self.headIcon:CreateSelf(self:FindGO("PlayerHeadCell", self.objHeadRoot))
  self.headIcon:SetMinDepth(3)
  self.serverGO = self:FindGO("Server")
  self.serverLabel = self.serverGO:GetComponent(UILabel)
end

function SkadaHistoryRecordCell:AddListenEvt()
  self.headIcon:AddCellClickEvent()
  self.headIcon:AddEventListener(MouseEvent.MouseClick, self.OnClickHead, self)
end

function SkadaHistoryRecordCell:SetData(data)
  self.data = data
  if not self.gameObject then
    return
  end
  self.objHeadRoot:SetActive(data ~= nil)
  self.objEmpty:SetActive(data == nil)
  self.labPlayerName.text = data and data.name
  if data then
    if data.averageDamage < 10000 then
      self.labDPS.text = string.format("%.1f", data.averageDamage)
    else
      local millionNum = math.modf(data.averageDamage / 1000000)
      local thousandStr = string.format("%.1f", math.fmod(data.averageDamage, 1000000) / 1000) .. "K"
      self.labDPS.text = string.format(ZhString.SkadaRecord_DPS, 0 < millionNum and millionNum .. "M" .. thousandStr or thousandStr)
    end
    local proData = Table_Class[data.profession]
    if proData then
      local setSuccess = IconManager:SetNewProfessionIcon(proData.icon, self.sprProfessionIcon)
      self.objProfession:SetActive(setSuccess == true)
      if setSuccess then
        self.sprProfessionColor.color = ProfessionProxy.Instance:SafeGetColorFromColorUtil("CareerIconBg" .. proData.Type)
      end
    else
      self.objProfession:SetActive(false)
      LogUtility.Error(string.format("Cannot find %d in Table_Class", data.profession))
    end
    self.headData:Reset()
    self.headData:TransByDamageUserData(data)
    if self.headData.iconData.type == HeadImageIconType.Avatar then
      self.headIcon:SetData(self.headData.iconData)
    elseif self.headData.iconData.type == HeadImageIconType.Simple then
      self.headIcon:SetSimpleIcon(self.headData.icon, self.headData.frameType)
    end
    if data.serverid and data.serverid ~= 0 and data.serverid ~= MyselfProxy.Instance:GetServerId() then
      self.serverGO:SetActive(true)
      self.serverLabel.text = data.serverid
    else
      self.serverGO:SetActive(false)
    end
  else
    self.labDPS.text = ""
  end
end

function SkadaHistoryRecordCell:OnClickHead(cellctrl)
  self:PassEvent(MouseEvent.MouseClick, self)
end

function SkadaHistoryRecordCell:OnCellDestroy()
  TableUtility.TableClear(self)
end
