return function(mediator)

  function move(data)
    print(data.id .. " moving to " .. data.x  .. "," .. data.y .. " at speed " .. data.speed)
  end

  mediator.subscribe({ 'move' }, move)
end
