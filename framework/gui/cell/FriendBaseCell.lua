autoImport("SocialBaseCell")
local baseCell = autoImport("BaseCell")
FriendBaseCell = class("FriendBaseCell", SocialBaseCell)

function FriendBaseCell:Init()
  self:FindObjs()
  self:InitShow()
end

function FriendBaseCell:FindObjs()
  FriendBaseCell.super.FindObjs(self)
  self.mask = self:FindGO("Mask")
  self.offlinetimeGO = self:FindGO("Offlinetime")
  if self.offlinetimeGO ~= nil then
    self.offlinetime = self.offlinetimeGO:GetComponent(UILabel)
    self.offlineTip = self:FindGO("OfflineTip"):GetComponent(UILabel)
  end
  self.zone = self:FindGO("Zone"):GetComponent(UILabel)
  self.zoneGO = self.zone.gameObject
  self.server = self:FindGO("Server"):GetComponent(UILabel)
  self.serverGO = self.server.gameObject
  self.cheatMark = self:FindGO("CheatMark")
end

function FriendBaseCell:InitShow()
  FriendBaseCell.super.InitShow(self)
  if self.offlinetimeGO ~= nil then
    self:AddGameObjectComp()
    self.timeTick = TimeTickManager.Me():CreateTick(0, 60000, self.RefreshOfflinetime, self)
  end
end

function FriendBaseCell:SetData(data)
  FriendBaseCell.super.SetData(self, data)
  if data then
    if data.offlinetime == 0 or AfkProxy.ParseIsAfk(data.afk) then
      if self.offlinetimeGO ~= nil then
        self.offlinetimeGO:SetActive(false)
      end
      self.mask:SetActive(false)
      self.headIcon:SetActive(true, true)
      if data.serverid and data.serverid ~= 0 and data.serverid ~= MyselfProxy.Instance:GetServerId() then
        self.zoneGO:SetActive(false)
        self.serverGO:SetActive(true)
        self.server.text = data.serverid
        self:UpdateOfflineTip(ZhString.Friend_MapOnline)
      else
        self.serverGO:SetActive(false)
        if data.zoneid and data.zoneid ~= 0 and MyselfProxy.Instance:GetZoneId() ~= data.zoneid then
          self.zoneGO:SetActive(true)
          self.zone.text = ChangeZoneProxy.Instance:ZoneNumToString(data.zoneid)
          self:UpdateOfflineTip("")
        else
          self.zoneGO:SetActive(false)
          self:UpdateOfflineTip(ZhString.Friend_MapOnline)
        end
      end
    else
      if self.offlinetimeGO ~= nil then
        self.offlinetimeGO:SetActive(true)
      end
      self.mask:SetActive(true)
      self.headIcon:SetActive(false, true)
      self.zoneGO:SetActive(false)
      if data.serverid and data.serverid ~= 0 and data.serverid ~= MyselfProxy.Instance:GetServerId() then
        self.serverGO:SetActive(true)
        self.server.text = data.serverid
      else
        self.serverGO:SetActive(false)
      end
      self:UpdateOfflineTip(ZhString.Friend_MapOffline)
    end
    self:RefreshOfflinetime()
    if self.cheatMark ~= nil then
      self.cheatMark:SetActive(data.cheatMark)
    end
  end
end

function FriendBaseCell:UpdateOfflineTip(tip)
  if self.offlinetimeGO == nil then
    return
  end
  self.offlineTip.text = tip
end

function FriendBaseCell:RefreshOfflinetime()
  if self.offlinetimeGO == nil then
    return
  end
  if self.data and self.data.offlinetime and self.data.offlinetime ~= 0 then
    self.offlinetime.text = ClientTimeUtil.GetFormatOfflineTimeStr(self.data.offlinetime)
  end
end

function FriendBaseCell:OnDestroy()
  TimeTickManager.Me():ClearTick(self)
end
