local baseCell = autoImport("BaseCell")
ResultInfoCell = class("ResultInfoCell", baseCell)
local CampConfig = GameConfig.TwelvePvp.CampConfig
local _TwelvePvpProxy = TwelvePvPProxy.Instance

function ResultInfoCell:Init()
  self:FindObjs()
end

function ResultInfoCell:FindObjs()
  self.title = self:FindGO("title"):GetComponent(UILabel)
  self.killLabel = self:FindGO("killLabel"):GetComponent(UILabel)
  self.killNum = self:FindGO("killNum"):GetComponent(UILabel)
  self.ExpLabel = self:FindGO("ExpLabel"):GetComponent(UILabel)
  self.EXP = self:FindGO("EXP"):GetComponent(UILabel)
  self.mvpNum = self:FindGO("mvpNum"):GetComponent(UILabel)
  self.TowerName = self:FindGO("TowerName"):GetComponent(UILabel)
  self.hpProgress = self:FindGO("HPProgress"):GetComponent(UISlider)
  self.hpPercent = self:FindGO("HPPercent"):GetComponent(UILabel)
end

function ResultInfoCell:SetData(data)
  if data then
    self.data = data
    self.camp = data.camp
    if CampConfig[self.camp] then
      self.title.text = CampConfig[self.camp].name
      self.killLabel.text = ZhString.TwelvePVP_Result_Kill
      self.killNum.text = data.kill_num
      self.ExpLabel.text = ZhString.TwelvePVP_Result_Exp
      self.EXP.text = data.exp
      self.mvpNum.text = data.kill_mvp
      local towerdata = _TwelvePvpProxy:GetFrontlineData(self.camp)
      if towerdata and towerdata.id then
        self.TowerName.text = Table_Monster[towerdata.id] and Table_Monster[towerdata.id].NameZh
        self.hpProgress.value = towerdata.currenthp / 100
        self.hpPercent.text = string.format("%d%%", towerdata.currenthp)
      end
    end
  end
end

function ResultInfoCell:SetCurrent(npcid, setHP)
  if not npcid then
    return
  end
  currenthp = _TwelvePvpProxy:GetHPPercentByNPCID(npcid) or 0
  self.hpProgress.value = currenthp / 100
  self.hpPercent.text = string.format("%d%%", currenthp)
end

function ResultInfoCell:SetBroken()
  self.hpProgress.value = 0
  self.hpPercent.text = "0%"
end

function ResultInfoCell:SetFull()
  self.hpProgress.value = 1
  self.hpPercent.text = "100%"
end
