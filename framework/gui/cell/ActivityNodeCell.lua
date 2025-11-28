local BaseCell = autoImport("BaseCell")
ActivityNodeCell = class("ActivityNodeCell", BaseCell)

function ActivityNodeCell:Init()
  self.bg = self:FindGO("BG")
  self.bg_boxcollider = self.bg:GetComponent(BoxCollider)
  self.ActivityTitle = self:FindGO("ActivityTitle", self.bg):GetComponent(UILabel)
  self.ActivityTime = self:FindGO("Time", self.bg):GetComponent(UILabel)
  self.btnGO = self:FindGO("GoBtn")
  self:SetEvent(self.bg, function()
    self:PassEvent(MouseEvent.MouseClick, self)
  end)
  self:SetEvent(self.btnGO, function(go)
    self:PassEvent(ActivityNodeCellEvent.ClickGoBtn, self)
  end)
  self.activityPic = self:FindComponent("Pic", UITexture)
end

function ActivityNodeCell:SetData(data)
  self.data = data
  self.index = data.index
  self.ActivityTitle.text = data.title
  self.photourls = data.photourls
  self:SetActivityTime(data.starttime, data.endtime)
  self.desc = data.desc
  self.rewards = data.rewards
  self:SetGoBtn(data.tracetype)
end

function ActivityNodeCell:LoadTexture()
  self:PassEvent(ActivityNodeCellEvent.GetIconTexture, self)
end

function ActivityNodeCell:SetActivityTime(starttime, endtime)
  self.ActivityTime.text = string.format(ZhString.ActivityData_Time, starttime, endtime)
end

function ActivityNodeCell:SetGoBtn(tracetype)
  if tracetype ~= nil then
    if tracetype == 0 then
      self.btnGO.gameObject:SetActive(false)
    else
      self.btnGO.gameObject:SetActive(true)
    end
  end
end

local tempV3 = LuaVector3()

function ActivityNodeCell:RefreshCellSize(activityNum)
  self.nodenum = activityNum
  local num = activityNum
  local single = GameConfig.ActivityOverviewLayout.ActivityNum[num]
  self.activityPic.width = single[self.index].picWidth
  self.activityPic.height = single[self.index].picHeight
  local pos = single[self.index].cellPos
  if pos then
    LuaVector3.Better_Set(tempV3, pos[1], pos[2], pos[3])
  end
  self.gameObject.transform.localPosition = tempV3
  self.bg_boxcollider.size = LuaVector3(self.activityPic.width, self.activityPic.height + 60, 0)
  self.curWidth = self.activityPic.width
  self.curHeight = self.activityPic.height
end

function ActivityNodeCell:setTextureByBytes(bytes)
  local texture = Texture2D(2, 2, TextureFormat.RGB24, false)
  local bRet = ImageConversion.LoadImage(texture, bytes)
  if bRet then
    self:setTexture(texture)
  else
    Object.DestroyImmediate(texture)
  end
end

function ActivityNodeCell:setTexture(texture)
  if texture then
    Object.DestroyImmediate(self.activityPic.mainTexture)
    self.activityPic.mainTexture = texture
    self.activityPic:MakePixelPerfect()
  end
end

function ActivityNodeCell:OnCellDestroy()
  if self.activityPic.mainTexture ~= nil then
    Object.DestroyImmediate(self.activityPic.mainTexture)
    self.activityPic.mainTexture = nil
  end
end
