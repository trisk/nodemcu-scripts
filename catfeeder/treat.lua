gpio0 = 3

function dispense(pin, ms)
  gpio.mode(pin, gpio.OUTPUT)
  if ms == 0 then
    gpio.write(pin, gpio.LOW)
    return
  end
  print("GPIO0 on")
  gpio.write(pin, gpio.HIGH)
  tmr.alarm(0, ms, 0, function()
    gpio.write(pin, gpio.LOW)
    print("GPIO0 off after " .. ms .. " ms")
  end)
end

dispense(gpio0, 0)
