autoImport("BMLeftChildCell")
DMMapListChildCell = class("DMMapListChildCell", BMLeftChildCell)

function DMMapListChildCell:Init()
  self.super.Init(self)
  self.Img2 = self:FindComponent("Img2", UISprite)
  self.Img3 = self:FindComponent("Img3", UISprite)
  self.ImgGrid = self:FindComponent("ImgGrid", UIGrid)
end

function DMMapListChildCell:SetData(data)
  self.super.SetData(self, data)
  if data.Img and self.ImgGrid then
    self.Img.gameObject:SetActive(false)
    self.Img2.gameObject:SetActive(false)
    self.Img3.gameObject:SetActive(false)
    if data.Img[1] then
      self.Img.gameObject:SetActive(true)
      IconManager:SetMapIcon(data.Img[1], self.Img)
      self.Img.width = 25
      self.Img.height = 25
    end
    if data.Img[2] then
      self.Img2.gameObject:SetActive(true)
      IconManager:SetMapIcon(data.Img[2], self.Img2)
      self.Img2.width = 25
      self.Img2.height = 25
    end
    if data.Img[3] then
      self.Img3.gameObject:SetActive(true)
      IconManager:SetMapIcon(data.Img[3], self.Img3)
      self.Img3.width = 25
      self.Img3.height = 25
    end
    self.ImgGrid:Reposition()
  end
  if not self.linkIcon and data.Pos and data.iconContainer then
    self.linkIcon = self:LoadPreferb("cell/DMMapIntroIconCell", data.iconContainer.gameObject)
    local sp = self.linkIcon:GetComponent(UISprite)
    IconManager:SetMapIcon(data.Img[1], sp)
    sp.width = 25
    sp.height = 25
    self.linkIcon.gameObject.transform.localPosition = LuaGeometry.GetTempVector3(data.Pos[1], data.Pos[2], 0)
  end
end

function DMMapListChildCell:SetChoose(choose)
end
