autoImport("PlayerTip")
PetTip = class("PetTip", PlayerTip)
local tempVector3 = LuaVector3.Zero()

function PetTip:Init()
  self:InitTip()
  self:AddListener()
end

function PetTip:InitTip()
  local cellObj = self:FindGO("HeadFace")
  self.faceCell = PlayerFaceCell.new(cellObj)
  self.faceCell:HideHpMp()
  self.favorObj = self:FindGO("Favor")
  self.bg = self:FindComponent("Bg", UISprite)
  self.lv = self:FindComponent("Lv", UILabel)
  self.name = self:FindComponent("Name", UILabel)
  self.masterName = self:FindComponent("MasterName", UILabel)
  self.favor = self.favorObj:GetComponent(UILabel)
  self.favorLabel = self:FindComponent("Label", UILabel, self.favorObj)
  self.labExpireTime = self:FindComponent("labExpireTime", UILabel)
  self.closecomp = self.gameObject:GetComponent(CloseWhenClickOtherPlace)
  
  function self.closecomp.callBack(go)
    self:CloseSelf()
  end
  
  local sgrid = self:FindComponent("SocialGrid", UIGrid)
  self.socialCtl = UIGridListCtrl.new(sgrid, SocialIconCell, "SocialIconCell")
  self.socialCtl:AddEventListener(MouseEvent.MouseClick, self.ClickCell, self)
  self.autoBattleBtn = self:FindGO("AutoBattleBtn")
  self:AddClickEvent(self.autoBattleBtn, function()
    local key = "Pet_AutoFight"
    local func = FunctionPlayerTip.Me():GetFuncByKey(key)
    if func then
      func(self.playerTipData)
    end
    if self.clickcallback then
      self.clickcallback(funcData)
    end
    local cfg = PlayerTipFuncConfig[key]
    if not cfg or not cfg.noCloseTip then
      self:CloseSelf()
    end
  end)
  self.closeAutoBattle = self:FindGO("CloseAutoBattle", self.autoBattleBtn)
end

function PetTip:CloseSelf()
  if self.closecallback then
    self.closecallback()
  end
  local playerTip = TipsView.Me().currentTip
  if playerTip and playerTip.__cname == "PetTip" then
    TipsView.Me():HideCurrent()
  end
end

function PetTip:SetData(data)
  xdlog("SetData")
  self.closecomp:ClearTarget()
  if data then
    local playerTipData = data.playerData
    if playerTipData then
      local headData = playerTipData.headData
      self.faceCell:SetData(headData)
      local level = playerTipData.level or 0
      self.name.text = playerTipData.name
      if 0 < level then
        self.lv.gameObject:SetActive(true)
        self.lv.text = string.format("Lv.%s", level)
      else
        self.lv.gameObject:SetActive(false)
      end
      local showId = playerTipData.id
      if type(showId) ~= "number" then
        showId = tonumber(showId)
      end
      if type(showId) == "number" then
        self:AcitiveIdObj(true)
        local limitNum = math.floor(math.pow(10, 12))
        self.favorLabel.text = string.format("%s", math.floor(showId % limitNum))
        self.favor.text = "ID:"
      else
        self:AcitiveIdObj(false)
      end
      self:UpdateTipFunc(data.funckeys, playerTipData)
      self.playerTipData = playerTipData
      self:UpdateAutoFightBtn(playerTipData)
    end
    self.closecallback = data.closecallback
  end
end

function PetTip:AcitiveIdObj(b)
  self.favorObj:SetActive(b)
end

function PetTip:UpdateTipFunc(funckeys, playerTipData)
  funckeys = funckeys or FunctionPlayerTip.Me():GetPlayerFunckey(playerTipData.id)
  if funckeys then
    local funcDatas = {}
    local socialDatas = {}
    FunctionPlayerTip.Me():SetWhereIClickThisIcon(self:GetWhereIClickThisIcon())
    for i = 1, #funckeys do
      local state, otherName, isCancel = FunctionPlayerTip.Me():CheckTipFuncStateByKey(funckeys[i], playerTipData)
      local socialState = FunctionPlayerTip.Me():CheckTipSocialStateByKey(funckeys[i], playerTipData)
      if state ~= PlayerTipFuncState.InActive and socialState == 0 then
        local tempData = {}
        tempData.key = funckeys[i]
        tempData.state = state
        tempData.playerTipData = playerTipData
        tempData.otherName = otherName
        table.insert(funcDatas, tempData)
      elseif state ~= PlayerTipFuncState.InActive and socialState ~= 0 then
        local singleData = {}
        singleData.key = funckeys[i]
        singleData.socialState = socialState
        singleData.playerTipData = playerTipData
        singleData.otherName = otherName
        table.insert(socialDatas, singleData)
        table.sort(socialDatas, function(l, r)
          local lstate = math.modf(l.socialState / 10)
          local rstate = math.modf(r.socialState / 10)
          return lstate < rstate
        end)
      end
    end
    self.socialCtl:ResetDatas(socialDatas)
  end
  TipsView.Me():ConstrainCurrentTip()
end

function PetTip:UpdateAutoFightBtn(ptdata)
  if ptdata == nil then
    self.autoBattleBtn:SetActive(false)
  end
  local myPetInfo
  if ptdata.petid then
    myPetInfo = PetProxy.Instance:GetMyPetInfoData(ptdata.petid)
  elseif ptdata.beingid then
    myPetInfo = PetProxy.Instance:GetMyBeingNpcInfo(ptdata.beingid)
  end
  if myPetInfo == nil then
    self.autoBattleBtn:SetActive(false)
  end
  if myPetInfo:IsAutoFighting() then
    self.closeAutoBattle:SetActive(true)
  else
    self.closeAutoBattle:SetActive(false)
  end
end

function PetTip:SetDesc(s1, s2, s3)
  self.name.text = s1
  self.masterName.text = s2
  self.masterName.color = LuaColor.White()
  self.favor.text = s3
  self.favorLabel.text = ""
end
