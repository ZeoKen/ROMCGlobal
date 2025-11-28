HomeMagicBookManager = class("HomeMagicBookManager")
local magicBookStaticType = 943

function HomeMagicBookManager:ctor()
  EventManager.Me():AddEventListener(ServiceEvent.WeatherWeatherChange, self.RefreshMagicBooks, self)
end

function HomeMagicBookManager:ExitEditMode()
  self:RefreshMagicBooks()
end

function HomeMagicBookManager:RefreshMagicBooks()
  local weatherId = ServiceWeatherProxy.Instance.weatherID
  local animeId = GameConfig.Home.WeatherEffect[weatherId]
  if not animeId then
    local staticFData = Table_HomeFurniture[38027]
    if weatherId == 0 then
      animeId = staticFData.FurnitureFunction[1] and staticFData.FurnitureFunction[1].param.OffAction
    else
      animeId = staticFData.IdleAction
    end
  end
  self:PlayMagicBooksAction(animeId)
end

function HomeMagicBookManager:PlayMagicBooksAction(animeId)
  local anime = animeId and Table_ActionAnime[animeId]
  if not anime then
    return
  end
  local magicBooks = self:GetMagicBooks()
  if magicBooks then
    for _, book in pairs(magicBooks) do
      book:PlayAction(anime.Name)
    end
  end
end

function HomeMagicBookManager:CheckIsMagicBook(nFurniture)
  if not nFurniture or not nFurniture.data then
    return false
  end
  return nFurniture.data:GetItemType() == magicBookStaticType
end

function HomeMagicBookManager:GetMagicBooks()
  return HomeManager.Me():GetFurnituresByStaticType(magicBookStaticType)
end
