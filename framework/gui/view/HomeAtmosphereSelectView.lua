HomeAtmosphereSelectView = class("HomeAtmosphereSelectView", BaseView)
HomeAtmosphereSelectView.ViewType = UIViewType.PopUpLayer
HomeAtmosphereSelectMap = {
  27,
  28,
  26
}

function HomeAtmosphereSelectView:Init()
  self:AddEvents()
  self:InitData()
  self:FindObjs()
  self:InitView()
end

function HomeAtmosphereSelectView:AddEvents()
  self:AddListenEvt(ServiceEvent.WeatherWeatherChange, self.OnWeatherChange)
  self:AddListenEvt(HomeEvent.ExitHome, self.CloseSelf)
end

function HomeAtmosphereSelectView:InitData()
  local viewData = self.viewdata.viewdata
  self.furniture = viewData and viewData.furniture
  if not self.furniture then
    LogUtility.Error("Cannot get furniture when initializing HomeAtmosphereSelectView!")
  end
end

function HomeAtmosphereSelectView:FindObjs()
  self.waypointParent = self:FindGO("Waypoints")
  for i = 1, 2 do
    self["waypoint" .. i] = self:FindGO(tostring(i), self.waypointParent).transform
  end
  self.btnParent = self:FindGO("BtnParent")
  self.btns = {}
  local btn
  for i = 1, 3 do
    btn = self:FindGO("Btn" .. tostring(i), self.btnParent)
    if btn then
      self.btns[i] = btn
    end
  end
  self.clickZone = self:FindGO("ClickZone")
  self.chooseSymbol = self:FindGO("ChooseSymbol")
end

function HomeAtmosphereSelectView:InitView()
  local screenPos = CameraController.Instance.activeCamera:WorldToScreenPoint(self.furniture:GetPosition())
  local _, h = UIManagerProxy.Instance:GetMyMobileScreenSize()
  local ratio = h / Screen.height
  local logicX = (screenPos.x - Screen.width / 2) * ratio
  local logicY = (screenPos.y - Screen.height / 2) * ratio + 60
  self.waypointParent.transform.localPosition = LuaGeometry.GetTempVector3(logicX, logicY, 0)
  for i = 1, 3 do
    self:AddClickEvent(self.btns[i], function()
      local weatherId = HomeAtmosphereSelectMap[i]
      self:CallAtmosphereSelect(ServiceWeatherProxy.Instance.weatherID == weatherId and 0 or weatherId)
    end)
  end
  self:AddClickEvent(self.clickZone, function()
    self:PlayFarewellAnimThenExit()
  end)
  self:UpdateChooseSymbol()
end

function HomeAtmosphereSelectView:OnEnter()
  HomeAtmosphereSelectView.super.OnEnter(self)
  self:PlayEncounterAnim()
end

function HomeAtmosphereSelectView:OnWeatherChange()
  self:UpdateChooseSymbol()
end

function HomeAtmosphereSelectView:UpdateChooseSymbol()
  self.chooseSymbol:SetActive(false)
  local weatherId = ServiceWeatherProxy.Instance.weatherID
  for index, id in pairs(HomeAtmosphereSelectMap) do
    if id == weatherId then
      local newX = self.btns[index].transform.localPosition.x
      local tempV3 = LuaGeometry.TempGetLocalPosition(self.chooseSymbol.transform)
      tempV3.x = newX
      self.chooseSymbol.transform.localPosition = tempV3
      self.chooseSymbol:SetActive(true)
      break
    end
  end
end

function HomeAtmosphereSelectView:PlayEncounterAnim()
  local tt = TweenTransform.Begin(self.btnParent, 0.6, self.waypoint1, self.waypoint2)
  tt.method = 2
  self.exiting = false
end

function HomeAtmosphereSelectView:PlayFarewellAnimThenExit()
  if self.exiting then
    return
  end
  self.exiting = true
  local tween = TweenTransform.Begin(self.btnParent, 0.6, self.waypoint2, self.waypoint1)
  tween.method = 1
  tween:SetOnFinished(function()
    self:CloseSelf()
  end)
end

function HomeAtmosphereSelectView:CallAtmosphereSelect(weatherId)
  ServiceHomeCmdProxy.Instance:CallFurnitureOperHomeCmd(HomeProxy.Oper.Weather, self.furniture.data.id, weatherId)
end
