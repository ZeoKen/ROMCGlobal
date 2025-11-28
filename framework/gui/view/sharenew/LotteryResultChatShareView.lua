autoImport("LotteryResultShareCell")
LotteryResultChatShareView = class("LotteryResultChatShareView", ContainerView)
LotteryResultChatShareView.ViewType = UIViewType.ShareLayer
local GetLocalPosition = LuaGameObject.GetLocalPosition

function LotteryResultChatShareView:Init()
  self:FindObjs()
  self:InitShow()
  local rologo = self:FindGO("Logo")
  local texName = GameConfig.Share.Logo
  local logoTex = rologo:GetComponent(UITexture)
  PictureManager.Instance:SetPlayerRefluxTexture(texName, logoTex)
  self:AddButtonEvent("BgClick", function(go)
    self:CloseSelf()
  end)
end

function LotteryResultChatShareView:FindObjs()
  self.effectContainer = self:FindGO("EffectContainer")
  self.extraEffectContainer = self:FindGO("ExtraEffectContainer")
  self.specialBg = self:FindGO("SpecialBg")
end

function LotteryResultChatShareView:InitShow()
  local data = self.viewdata.viewdata.data
  if data then
    self.list = {}
    self.extraList = {}
    local mid = math.floor(#data / 2)
    for i = 1, mid do
      self.list[#self.list + 1] = data[i]:Clone()
    end
    for i = mid + 1, #data do
      self.extraList[#self.extraList + 1] = data[i]:Clone()
    end
    local myName = self:FindGO("myName"):GetComponent(UILabel)
    myName.text = self.viewdata.viewdata.name
    local serverName = self:FindGO("ServerName"):GetComponent(UILabel)
    local curServer = FunctionLogin.Me():getCurServerData()
    local serverID = curServer and curServer.name or 1
    serverName.text = serverID
    if BranchMgr.IsJapan() then
      myName.gameObject:SetActive(false)
      serverName.gameObject:SetActive(false)
      local bg_name = self:FindGO("bg_name")
      if bg_name then
        bg_name:SetActive(false)
      end
    end
    local grid = self:FindGO("Grid"):GetComponent(UIGrid)
    self.itemCtl = UIGridListCtrl.new(grid, LotteryResultShareCell, "LotteryResultShareCell")
    self.itemCtl:ResetDatas(self.list)
    local extraGrid = self:FindGO("ExtraGrid"):GetComponent(UIGrid)
    self.extraItemCtl = UIGridListCtrl.new(extraGrid, LotteryResultShareCell, "LotteryResultShareCell")
    self.extraItemCtl:ResetDatas(self.extraList)
    local itemCells = self.itemCtl:GetCells()
    local isFashion
    for i = 1, #itemCells do
      isFashion = itemCells[i].data and itemCells[i].data:IsClothFashion()
      self:SetNormal(self.effectContainer, isFashion, GetLocalPosition(itemCells[i].trans))
    end
    itemCells = self.extraItemCtl:GetCells()
    for i = 1, #itemCells do
      isFashion = itemCells[i].data and itemCells[i].data:IsClothFashion()
      if i == #itemCells then
        self:SetSpecial(self.extraEffectContainer, isFashion, GetLocalPosition(itemCells[i].trans))
      else
        self:SetNormal(self.extraEffectContainer, isFashion, GetLocalPosition(itemCells[i].trans))
      end
    end
  end
end

local effectName

function LotteryResultChatShareView:SetNormal(parent, isFashion, x, y, z)
  self.effect1 = self:PlayUIEffect(EffectMap.UI.Egg10BoomB, parent, true)
  self.effect1:ResetLocalPositionXYZ(x, y, z)
  effectName = isFashion and EffectMap.UI.ShareEgg10DritO or EffectMap.UI.Egg10DritB
  self.effect2 = self:PlayUIEffect(effectName, parent)
  self.effect2:ResetLocalPositionXYZ(x, y, z)
end

function LotteryResultChatShareView:SetSpecial(parent, isFashion, x, y, z)
  self.effect1 = self:PlayUIEffect(EffectMap.UI.Egg10BoomR, parent, true)
  self.effect1:ResetLocalPositionXYZ(x, y, z)
  effectName = isFashion and EffectMap.UI.ShareEgg10DritO or EffectMap.UI.Egg10DritR
  self.effect2 = self:PlayUIEffect(effectName, parent)
  self.effect2:ResetLocalPositionXYZ(x, y, z)
  self.specialBg:SetActive(true)
  self.specialBg.transform.localPosition = LuaGeometry.GetTempVector3(x + 40, y + 40, z)
end
