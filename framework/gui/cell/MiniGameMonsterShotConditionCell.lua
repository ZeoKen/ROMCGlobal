local BaseCell = autoImport("BaseCell")
MiniGameMonsterShotConditionCell = class("MiniGameMonsterShotConditionCell", BaseCell)

function MiniGameMonsterShotConditionCell:Init()
  self:FindObjs()
end

function MiniGameMonsterShotConditionCell:FindObjs()
  self.headIcon = self:FindComponent("SimpleHeadIcon", UISprite)
  self.symbol = self:FindComponent("symbol", UIMultiSprite)
  self.number = self:FindComponent("number", UILabel)
  self.result = self:FindComponent("result", UIMultiSprite)
  self.failReason = self:FindComponent("failReason", UILabel)
end

function MiniGameMonsterShotConditionCell:SetData(data)
  self.data = data
  if data then
    local setSuc = IconManager:SetFaceIcon(Table_Monster[data.monsterid].Icon, self.headIcon)
    if not setSuc then
      IconManager:SetFaceIcon(Table_Monster[10001].Icon, self.headIcon)
    end
    self.number.text = data.value
    self.result.gameObject:SetActive(data.checkOK ~= nil)
    self.failReason.text = ""
    if data.checkOK ~= nil then
      self.result.gameObject:SetActive(true)
      self.result.CurrentState = data.checkOK and 1 or 0
      if data.checkOK == false and data.realValue then
        self.result.gameObject:SetActive(false)
        self.failReason.text = data.realValue
      end
    end
    local sval = 0
    if data.cmptype == EMONSTERSHOTCOMPARE.EMONSTERSHOT_COMPARE_EQ then
      sval = 0
    elseif data.cmptype == EMONSTERSHOTCOMPARE.EMONSTERSHOT_COMPARE_LT then
      sval = 1
    elseif data.cmptype == EMONSTERSHOTCOMPARE.EMONSTERSHOT_COMPARE_GT then
      sval = -1
    end
    self.symbol.flip = sval < 0 and 1 or 0
    self.symbol.CurrentState = math.abs(sval)
    if data.showasplus then
      self.symbol.CurrentState = 3
      self.number.text = ""
      self.symbol.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(75, 0, 0)
    else
      self.symbol.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(55, 0, 0)
    end
    self.symbol.width = 24
    self.symbol.height = 22
  end
end
