function Structure.QueuePush(array, v)
  TableUtility.ArrayPushBack(array, v)
end

function Structure.QueuePop(array)
  return TableUtility.ArrayPopFront(array)
end

function Structure.QueuePeek(array)
  if #array <= 0 then
    return nil
  end
  return array[1]
end

function Structure.QueuePeekByIndex(array, index)
  if not (0 < #array) or not (index <= #array) then
    return nil
  end
  return array[index]
end
