autoImport("PlayerFaceCell")
TwelvePvpObserverHeadCell = class("TwelvePvpObserverHeadCell", PlayerFaceCell)
local tempV3 = LuaVector3()
local lowHpPercent = 0.5

function TwelvePvpObserverHeadCell:Init()
  self.lvmat = "%s"
  self.profession = self:FindGO("profession")
  self.proIcon = self:FindComponent("Icon", UISprite, self.profession)
  self.proColor = self:FindComponent("Color", UISprite, self.profession)
  if self.proIcon then
    tempV3:Set(0, 0, 0)
    self.proIcon.transform.localPosition = tempV3
  end
  if self.proColor then
    self.proColor.width = 36
    self.proColor.height = 36
    self.proColor.spriteName = "new-com_icon_career_b"
    tempV3:Set(0, 0, 0)
    self.proColor.transform.localPosition = tempV3
  end
  self.name = self:FindComponent("name", UILabel)
  if self.name then
    self.nameObj = self.name.gameObject
  end
  self.level = self:FindComponent("level", UILabel)
  self.vip = self:FindComponent("vip", UILabel)
  self.hp = self:FindComponent("hp", UISlider)
  self.mp = self:FindComponent("mp", UISlider)
  self.choosen = self:FindGO("ChoosenGO")
  self.attachGO = self:FindGO("AttachGO")
  self.dangerGO = self:FindGO("DangerGO")
  self.headRootSp = self:FindComponent("HeadRootSp", UISprite)
  self:InitHeadIconCell()
  self.headIconCell:HideFrame()
  self:AddCellClickEvent()
end

function TwelvePvpObserverHeadCell:SetPlayerPro(data)
  if self.profession then
    local proData = Table_Class[data.profession]
    if proData then
      if IconManager:SetProfessionIcon("new_" .. proData.icon, self.proIcon) then
        self.profession.gameObject:SetActive(true)
        local colorKey = "CareerIconBg" .. proData.Type
        self.proColorSave = ProfessionProxy.Instance:SafeGetColorFromColorUtil(colorKey)
        self.proColor.color = self.proColorSave
      else
        redlog("未在career_2 中找到资源 ： new_", proData.icon)
        self.profession.gameObject:SetActive(false)
      end
    else
      redlog("未找到class表配置 profession: ", data.profession)
    end
    self.proIcon.width = 38
    self:SetGoGrey(self.profession, data.offline and not AfkProxy.ParseIsAfk(self.data and self.data.iconData and self.data.iconData.afk))
  end
end

function TwelvePvpObserverHeadCell:InitHeadIconCell()
  self.headIconCell = HeadIconCell.new()
  self.headIconCell:CreateSelf(self.headRootSp.gameObject)
  self.headIconCell:SetMinDepth(3)
end

function TwelvePvpObserverHeadCell:RefreshSelf(data)
  TwelvePvpObserverHeadCell.super.RefreshSelf(self, data)
  if not self.data then
    return
  end
  self.attachId = 0
  self.chooseId = 0
  self.playerid = self.data.playerid
  self:UpdateAttach()
  self:UpdateChoosen()
  self:UpdateLowerHp()
  self:UpdateHpSp(self.data.hp, self.data.mp)
end

function TwelvePvpObserverHeadCell:SetChoosen(id)
  self.chooseId = id
  self:UpdateChoosen()
end

function TwelvePvpObserverHeadCell:UpdateChoosen()
  local isChoosen = self.playerid and self.playerid == self.chooseId
  if isChoosen == self.choosenCache then
    return
  end
  self.choosenCache = isChoosen
  self.choosen:SetActive(isChoosen)
end

function TwelvePvpObserverHeadCell:SetAttach(id)
  self.attachId = id
  self:UpdateAttach()
  self:SetChoosen(id)
end

function TwelvePvpObserverHeadCell:UpdateAttach()
  local isAttach = self.playerid and self.playerid == self.attachId
  if isAttach == self.attachCache then
    return
  end
  self.attachCache = isAttach
  self.attachGO:SetActive(isAttach)
  self.headRootSp.alpha = isAttach and 0.3 or 1
end

function TwelvePvpObserverHeadCell:UpdateLowerHp()
  local hpDanger = self.data and self.data.hp < lowHpPercent
  if hpDanger == self.cacheDanger then
    return
  end
  self.cacheDanger = hpDanger
  self.dangerGO:SetActive(hpDanger)
end

function TwelvePvpObserverHeadCell:UpdateHpSp(hp, sp)
  self:UpdateHp(hp / 100)
  self:UpdateMp(sp / 100)
end

function TwelvePvpObserverHeadCell:UpdateOffline()
  self:SetIconActive(false, true)
  self.attachGO:SetActive(false)
  self.headRootSp.alpha = 1
  self.choosen:SetActive(false)
end
