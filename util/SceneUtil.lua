SceneUtil = {}

function SceneUtil.SyncLoad(scene)
  pcall(function()
    if CompatibilityVersion.IsABSpb() then
      scene = string.lower(scene)
    end
  end)
  SceneManagement.SceneManager.LoadScene(scene)
end

function SceneUtil.AsyncLoad(scene)
  pcall(function()
    if CompatibilityVersion.IsABSpb() then
      scene = string.lower(scene)
    end
  end)
  SceneManagement.SceneManager.LoadLevelAsync(scene)
end
