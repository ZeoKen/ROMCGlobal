HTTPRequest = {}
local requestTextureMap = {}

function HTTPRequest.GetTexture(url, localpath, filename, complete_callback)
  local c = coroutine.create(function()
    local request = HTTPRequest.CreateUnityWebRequest(url, "GET")
    requestTextureMap[url] = request
    request.downloadHandler = UnityEngine.Networking.DownloadHandlerFile(localpath)
    request.timeout = 180
    Yield(request:SendWebRequest())
    helplog("texture request done")
    if complete_callback ~= nil then
      complete_callback(request, localpath, filename)
    end
    request:Dispose()
    request = nil
    requestTextureMap[url] = nil
  end)
  coroutine.resume(c)
end

function HTTPRequest.CancelTextureDownloading(url)
  if requestTextureMap ~= nil then
    for k, v in pairs(requestTextureMap) do
      if k == url then
        helplog("user cancel texture downloading")
        requestTextureMap[k]:Abort()
        break
      end
    end
  end
end

function HTTPRequest.Get(url, complete_callback, param)
  local c = coroutine.create(function()
    local request = HTTPRequest.CreateUnityWebRequest(url, "GET")
    request.downloadHandler = UnityEngine.Networking.DownloadHandlerBuffer()
    Yield(request:SendWebRequest())
    if complete_callback ~= nil then
      complete_callback(request, param)
    end
    request:Dispose()
    request = nil
  end)
  coroutine.resume(c)
end

local unityWebRequestPool = {}

function HTTPRequest.CreateUnityWebRequest(url, method)
  local request = Slua.CreateClass("UnityEngine.Networking.UnityWebRequest", url, method)
  return request
end

function HTTPRequest.GetUnityWebRequest(url, method)
  local request
  local requestIndex = 0
  for i = 1, #unityWebRequestPool do
    local tempUnityWebRequest = unityWebRequestPool[i]
    if not tempUnityWebRequest.isBusy then
      request = tempUnityWebRequest.request
      request.url = url
      request.method = method
      requestIndex = i
      tempUnityWebRequest.isBusy = true
    end
  end
  if request == nil then
    request = HTTPRequest.CreateUnityWebRequest(url, method)
    table.insert(unityWebRequestPool, {request = request, isBusy = true})
    requestIndex = #unityWebRequestPool
  end
  return request, requestIndex
end

function HTTPRequest.BackUnityWebRequestWithIndex(request_index)
  local unityWebRequest = unityWebRequestPool[request_index]
  HTTPRequest.BackUnityWebRequest(unityWebRequest)
end

function HTTPRequest.BackUnityWebRequest(request)
  if request ~= nil then
    request.isBusy = false
  end
end

local queueRequest = {}
local ticketCount = 10

function HTTPRequest.Head(url, complete_callback, param)
  if 0 < ticketCount then
    HTTPRequest.DoHead(url, complete_callback, param)
    ticketCount = ticketCount - 1
  else
    HTTPRequest.InQueueRequest(url, "HEAD", complete_callback, param)
  end
end

function HTTPRequest.DoHead(url, complete_callback, param)
  local c = coroutine.create(function()
    local request = HTTPRequest.CreateUnityWebRequest(url, "HEAD")
    Yield(request:SendWebRequest())
    if 0 < #queueRequest then
      HTTPRequest.QueueHeadDo()
    else
      ticketCount = ticketCount + 1
    end
    if complete_callback ~= nil then
      complete_callback(request, param)
    end
    request:Dispose()
    request = nil
  end)
  coroutine.resume(c)
end

function HTTPRequest.InQueueRequest(url, method, complete_callback, param)
  table.insert(queueRequest, {
    url = url,
    method = method,
    completeCallback = complete_callback,
    param = param
  })
end

function HTTPRequest.QueueHeadDo()
  local requestParam = queueRequest[1]
  table.remove(queueRequest, 1)
  if requestParam.method == "HEAD" then
    HTTPRequest.DoHead(requestParam.url, requestParam.completeCallback, requestParam.param)
  end
end
