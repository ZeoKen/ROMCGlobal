TwelvePVPDetailCell = class("TwelvePVPDetailCell", BaseCell)
local CampUIConfig = {
  [1] = LuaColor(1, 0.6862745098039216, 0.6862745098039216),
  [2] = LuaColor(0.6235294117647059, 0.796078431372549, 1)
}

function TwelvePVPDetailCell:Init()
  self:FindObjects()
end

function TwelvePVPDetailCell:FindObjects()
  self.bg = self:FindGO("bg"):GetComponent(UISprite)
  self.name = self:FindGO("name"):GetComponent(UILabel)
  self.kill = self:FindGO("kill"):GetComponent(UILabel)
  self.death = self:FindGO("death"):GetComponent(UILabel)
  self.heal = self:FindGO("heal"):GetComponent(UILabel)
  self.gold = self:FindGO("gold"):GetComponent(UILabel)
  self.exp = self:FindGO("exp"):GetComponent(UILabel)
  self.push = self:FindGO("push"):GetComponent(UILabel)
  self.mvp = self:FindGO("mvp"):GetComponent(UILabel)
  self.profession = self:FindComponent("sprProfession", UISprite)
end

function TwelvePVPDetailCell:SetData(data)
  self.data = data
  if self.data then
    self.campid = data.campid
    self.bg.color = CampUIConfig[self.campid] or CampUIConfig[1]
    self.name.text = data:GetName()
    self.kill.text = data.kill
    self.death.text = data.death
    self.heal.text = data.heal
    self.gold.text = data.gold
    self.exp.text = data.exp
    self.push.text = data.push
    self.mvp.text = data.mvp
    if self.data.profession then
      if type(self.data.profession) == "number" then
        local proData = Table_Class[self.data.profession]
        self.profession.gameObject:SetActive(proData and IconManager:SetNewProfessionIcon(proData.icon, self.profession) or false)
      elseif type(self.data.profession) == "string" then
        local success = IconManager:SetNewProfessionIcon(self.data.profession, self.profession) or IconManager:SetUIIcon(self.data.profession, self.profession)
        self.profession.gameObject:SetActive(success)
      end
    else
      self.profession.gameObject:SetActive(false)
    end
  else
    self.gameObject:SetActive(false)
  end
end
