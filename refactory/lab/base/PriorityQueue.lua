local ValueCompare_ = function(lhs, rhs)
  return lhs - rhs
end
local MinHeapShiftUp_ = function(array, size, n, comparator)
  if 0 == size then
    return
  end
  if size < n or n <= 1 then
    return
  end
  local temp = array[n]
  local holeN = n
  repeat
    local pn = math.floor(holeN * 0.5)
    if 0 ~= pn and 0 < comparator(array[pn], temp) then
      array[holeN] = array[pn]
      holeN = pn
    else
      break
    end
  until false
  if holeN ~= n then
    array[holeN] = temp
  end
end
local MinHeapShiftDown_ = function(array, size, n, comparator)
  if 0 == size then
    return
  end
  if size <= n or n < 1 then
    return
  end
  local temp = array[n]
  local holeN = n
  repeat
    local parentN = holeN
    local min = temp
    local ln = 2 * parentN
    if size < ln then
      break
    end
    if comparator(array[ln], min) < 0 then
      holeN = ln
      min = array[ln]
    end
    local rn = ln + 1
    if size >= rn and comparator(array[rn], min) < 0 then
      holeN = rn
      min = array[rn]
    end
    if holeN == parentN then
      break
    end
    array[parentN] = min
  until false
  if holeN ~= n then
    array[holeN] = temp
  end
end
local InitMinHeap_ = function(array, comparator)
  local size = #array
  if size < 2 then
    return
  end
  for n = math.floor(size * 0.5), 1, -1 do
    MinHeapShiftDown_(array, size, n, comparator)
  end
end
PriorityQueue = class("PriorityQueue")

function PriorityQueue:ctor(comparator)
  self.queue = {}
  if nil ~= comparator then
    self.comparator = comparator
  else
    self.comparator = ValueCompare_
  end
end

function PriorityQueue:GetSize()
  return #self.queue
end

function PriorityQueue:IsEmpty()
  return 0 == #self.queue
end

function PriorityQueue:Push(v)
  local queue = self.queue
  local n = #queue + 1
  queue[n] = v
  if 1 < n then
    MinHeapShiftUp_(queue, n, n, self.comparator)
  end
end

function PriorityQueue:Pop()
  local queue = self.queue
  local n = #queue
  if 0 == n then
    return nil
  end
  local v = queue[1]
  queue[1] = queue[n]
  queue[n] = nil
  if n <= 2 then
    return v
  end
  MinHeapShiftDown_(queue, n - 1, 1, self.comparator)
end

function PriorityQueue:Peek()
  return self.queue[1]
end
