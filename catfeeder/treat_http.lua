handlers["/"] = function(c, params)
  local buf = "<h1>ESP8266 Web Server</h1>"
  buf = buf .. "<p>GPIO0 <a href=\"?gpio0=1\"><button>ON</button></a>&nbsp;<a href=\"?gpio0=0\"><button>OFF</button></a>"
  buf = buf .. "<form action=\"\" method=\"GET\">"
  buf = buf .. "<label>ON for (milliseconds)</label><br/><input name=\"gpio0_time\" type=\"number\" value=\"1000\"/>"
  buf = buf .. "<input type=\"submit\"/></form></p>"

  if params.gpio0 == "1" then
    gpio.write(gpio0, gpio.HIGH)
  elseif params.gpio0 == "0" then
    gpio.write(gpio0, gpio.LOW)
  end
  if params.gpio0_time ~= nil then
    local time = tonumber(params.gpio0_time)
    if time >= 100 and time <= 10000 then
      dispense(gpio0, time)
    end
  end

  send_page(c, 200, buf)
end
