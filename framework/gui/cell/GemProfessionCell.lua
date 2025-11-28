local BaseCell = autoImport("BaseCell")
local _ProfessionCntOneLine = 3
local _TextBgColor = {
  Default = LuaColor.New(0.8784313725490196, 0.9254901960784314, 0.9686274509803922, 1),
  Choosen = LuaColor.New(1.0, 0.9529411764705882, 0.8705882352941177, 1)
}
GemProfessionCell = class("GemProfessionCell", BaseCell)

function GemProfessionCell:Init()
  self.titleRoot = self:FindGO("TitleRoot")
  self.titleLab = self:FindComponent("ProfessionTypeLab", UILabel, self.titleRoot)
  self.professionRoot = self:FindGO("ProfessionRoot")
  self.totalProfessionRoot = self:FindGO("TotalProfessionRoot")
  self.totalProfessionLab = self:FindComponent("Lab", UILabel, self.totalProfessionRoot)
  self.totalProfessionLab.text = ZhString.Gem_FilterAllProfession
  self:AddClickEvent(self.totalProfessionLab.gameObject, function()
    self:PassEvent(GemEvent.ClickProfession, 0)
  end)
  self.professionLabs = {}
  self.professionLabBg = {}
  for i = 1, _ProfessionCntOneLine do
    self.professionLabs[i] = self:FindComponent("ProfessionLab" .. tostring(i), UILabel)
    self.professionLabBg[i] = self:FindComponent("bg", UISprite, self.professionLabs[i].gameObject)
    self:AddClickEvent(self.professionLabs[i].gameObject, function()
      if not self.data then
        return
      end
      self:PassEvent(GemEvent.ClickProfession, self.data[i])
    end)
  end
end

function GemProfessionCell:SetData(data)
  self.data = data
  if type(data) == "string" then
    self:Show(self.titleRoot)
    self:Hide(self.professionRoot)
    self:Hide(self.totalProfessionRoot)
    self.titleLab.text = data
  elseif type(data) == "table" then
    self:Hide(self.titleRoot)
    self:Show(self.professionRoot)
    self:Hide(self.totalProfessionRoot)
    local myGender = MyselfProxy.Instance:GetMySex()
    local curChoosePro = GemProxy.Instance:GetCurNewProfession()
    local curTargetProfession = GemProxy.Instance.targetProfession
    for i = 1, _ProfessionCntOneLine do
      if data[i] and 0 < data[i] then
        self:Show(self.professionLabs[i])
        self.professionLabs[i].text = ProfessionProxy.GetProfessionName(data[i], myGender)
        if GemProxy.Instance.startChooseTargetProfession then
          self.professionLabBg[i].color = curTargetProfession == data[i] and _TextBgColor.Choosen or _TextBgColor.Default
        else
          self.professionLabBg[i].color = curChoosePro == data[i] and _TextBgColor.Choosen or _TextBgColor.Default
        end
      else
        self:Hide(self.professionLabs[i])
      end
    end
  elseif data == 0 then
    if GemProxy.Instance.startChooseTargetProfession then
      self:Hide(self.totalProfessionRoot)
    else
      self:Show(self.totalProfessionRoot)
    end
    self:Hide(self.titleRoot)
    self:Hide(self.professionRoot)
  end
end
