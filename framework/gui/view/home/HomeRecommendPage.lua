autoImport("HomeRecommendCell")
HomeRecommendPage = class("HomeRecommendPage", SubView)

function HomeRecommendPage:Init()
  self.timeStamp = {}
  self:FindObjs()
  self:AddListenEvts()
end

function HomeRecommendPage:FindObjs()
  self.gameObject = self:FindGO("HomeRecommendPage")
  local grid = self:FindComponent("Grid", UIGrid)
  self.homeListCtrl = UIGridListCtrl.new(grid, HomeRecommendCell, "HomeRecommendCell")
  self.homeListCtrl:AddEventListener(MouseEvent.MouseClick, self.OnHomeCellClick, self)
  local refreshBtn = self:FindGO("RefreshBtn")
  self:AddClickEvent(refreshBtn, function()
    self:OnRefreshBtnClick()
  end)
  self.noneTip = self:FindGO("NoneTip")
  self.noneTip:SetActive(true)
end

function HomeRecommendPage:AddListenEvts()
  self:AddListenEvt(ServiceEvent.HomeCmdQueryRecommendHomeCmd, self.OnRefreshSuccess)
  self:AddListenEvt(FunctionPhotoStorage.OnPhotoDownloadFinish, self.OnPhotoDownloadFinish)
  self:AddListenEvt(HomeEvent.GotoHome, self.OnGotoHome)
end

function HomeRecommendPage:OnGotoHome()
  self.container:CloseSelf()
end

function HomeRecommendPage:RefreshView()
  local curTimeStamp = ServerTime.CurServerTime() / 1000
  local cd = GameConfig.Home.Recommend and GameConfig.Home.Recommend.PageClickCD or 10
  if self.timeStamp[self.houseType] and cd > curTimeStamp - self.timeStamp[self.houseType] then
    self:OnRefreshSuccess()
    return
  end
  self.timeStamp[self.houseType] = curTimeStamp
  local houseType = HomeProxy.HouseType2ServerHouseType[self.houseType]
  redlog("[HomeRecommendPage] 请求刷新 houseType = " .. tostring(houseType))
  ServiceHomeCmdProxy.Instance:CallQueryRecommendHomeCmd(nil, houseType)
end

function HomeRecommendPage:OnRefreshSuccess()
  redlog("HomeRecommendPage:OnRefreshSuccess self.houseType = " .. tostring(self.houseType))
  local houseType = HomeProxy.HouseType2ServerHouseType[self.houseType]
  local recommendList = HomeRecommendProxy.Instance:GetRecommendList(houseType)
  self.homeListCtrl:ResetDatas(recommendList)
  self.noneTip:SetActive(#recommendList == 0)
end

function HomeRecommendPage:OnPhotoDownloadFinish(note)
  local data = note and note.body
  if not data or data.type ~= FunctionPhotoStorage.PhotoType.HomeRecommend or not data.isThumb then
    return
  end
  local photoId = data.index
  local index = data.customParam
  redlog("HomeRecommendPage:OnPhotoDownloadFinish photoId = " .. tostring(photoId), "index = " .. tostring(index))
  local cells = self.homeListCtrl:GetCells()
  if not cells then
    return
  end
  for i = 1, #cells do
    local cell = cells[i]
    local cellData = cell and cell.data
    if cellData and cellData.photoId == photoId and cellData.index == index then
      if data.byte then
        cell:SetPhoto(data.byte)
        break
      end
      cell:ClearPhoto()
      LogUtility.Error(string.format("[HomeRecommendPage] Download failed: %s", tostring(data.error)))
      break
    end
  end
end

function HomeRecommendPage:OnHomeCellClick(cell)
  self:sendNotification(UIEvent.JumpPanel, {
    view = PanelConfig.HomePhotoResultPanel,
    viewdata = cell.data
  })
end

function HomeRecommendPage:OnRefreshBtnClick()
  self:RefreshView()
end

function HomeRecommendPage:OnSwitch(isShow, houseType)
  self.houseType = houseType
  if isShow then
    self:RefreshView()
  end
end

function HomeRecommendPage:OnHouseTypeSwitch(houseType)
  self.houseType = houseType
  local recommendList = HomeRecommendProxy.Instance:GetRecommendList(HomeProxy.HouseType2ServerHouseType[self.houseType])
  if 0 < #recommendList then
    self:OnRefreshSuccess()
  else
    self:RefreshView()
  end
end
