require("Script.Refactory.Header")
LogUtility.Info("!!!!!!!!!!!gamelaunch!!!!!!!!!!!!!")
if nil == g_Game then
  g_Game = Game.Me()
  Debug_LuaMemotry.Start()
end
return Game
