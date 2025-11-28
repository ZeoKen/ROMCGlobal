local BaseCell = autoImport("BaseCell")
NoviceTarget2023LevelCell = class("NoviceTarget2023LevelCell", BaseCell)

function NoviceTarget2023LevelCell:Init()
  self:FindObj()
  self:AddUIEvents()
end

function NoviceTarget2023LevelCell:FindObj()
  self.eleTable = self:FindComponent("eletable", UITable)
  self.fin = self:FindGO("fin")
  self.fin_Icon = self.fin:GetComponent(UISprite)
  self.lock = self:FindGO("lock")
  self.BtnText_n = self:FindComponent("BtnText_n", UILabel)
  self.BtnText_s = self:FindComponent("BtnText_s", UILabel)
  self.fff = self:FindGO("fff")
  self.nnn = self:FindGO("nnn")
  self.fff_n = self:FindGO("n", self.fff)
  self.fff_s = self:FindGO("s", self.fff)
  self.nnn_n = self:FindGO("n", self.nnn)
  self.nnn_s = self:FindGO("s", self.nnn)
  self.widget = self.gameObject:GetComponent(UIWidget)
  self.fff_n_sp = self.fff_n:GetComponent(UISprite)
  self.fff_s_sp = self.fff_s:GetComponent(UISprite)
  self.nnn_n_sp = self.nnn_n:GetComponent(UISprite)
  self.nnn_s_sp = self.nnn_s:GetComponent(UISprite)
  self.redtip = self:FindGO("Redtip")
end

function NoviceTarget2023LevelCell:AddUIEvents()
  self:AddClickEvent(self.gameObject, function(go)
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
end

function NoviceTarget2023LevelCell:SetData(data)
  self.data = data
  self.id = data.id
  self.isFirst = data.isFirst
  if self.isFirst then
    self.fff:SetActive(true)
    self.nnn:SetActive(false)
    self.s = self.fff_s
    self.n = self.fff_n
  else
    self.fff:SetActive(false)
    self.nnn:SetActive(true)
    self.s = self.nnn_s
    self.n = self.nnn_n
  end
  if data.s_fin then
    self.fin:SetActive(true)
    self.lock:SetActive(false)
  elseif data.s_lock then
    self.fin:SetActive(false)
    self.lock:SetActive(true)
  else
    self.fin:SetActive(false)
    self.lock:SetActive(false)
  end
  self.isNumberLv = data.isNumberLv
  if self.isNumberLv then
    self.fff_n_sp.width = 142
    self.fff_s_sp.width = 142
    self.nnn_n_sp.width = 142
    self.nnn_s_sp.width = 142
    self.widget.width = 142
    self.redtip.transform.localPosition = LuaGeometry.GetTempVector3(52, 19, 0)
  else
    self.fff_n_sp.width = 282
    self.fff_s_sp.width = 282
    self.nnn_n_sp.width = 282
    self.nnn_s_sp.width = 282
    self.widget.width = 282
    self.redtip.transform.localPosition = LuaGeometry.GetTempVector3(120, 19, 0)
  end
  self.BtnText_s.text = data.name
  self.BtnText_n.text = data.name
  self.BtnText_s.overflowMethod = 2
  self.BtnText_s:UpdateNGUIText()
  local length = NGUIText.CalculatePrintedSize(self.BtnText_s.text).x
  if 252 < length then
    self.BtnText_s.overflowMethod = 0
    self.BtnText_s.width = 252
  end
  self.BtnText_n.overflowMethod = 2
  self.BtnText_n:UpdateNGUIText()
  local length = NGUIText.CalculatePrintedSize(self.BtnText_n.text).x
  if 252 < length then
    self.BtnText_n.overflowMethod = 0
    self.BtnText_n.width = 252
  end
  self:SetSelected(data.s_select)
  self.redtip:SetActive(data.red)
end

function NoviceTarget2023LevelCell:SetSelected(isTrue)
  isTrue = isTrue or false
  self.s:SetActive(isTrue)
  self.n:SetActive(not isTrue)
  self.BtnText_s.gameObject:SetActive(isTrue)
  self.BtnText_n.gameObject:SetActive(not isTrue)
  self.fin_Icon.color = isTrue and LuaGeometry.GetTempVector4(0.21176470588235294, 0.37254901960784315, 0.6666666666666666, 1) or LuaGeometry.GetTempVector4(0.3568627450980392, 0.5450980392156862, 0.7098039215686275, 1)
  self.eleTable:Reposition()
end
