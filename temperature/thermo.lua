gpio0 = 3
ds18b20 = require('ds18b20')
ds18b20.setup(gpio0)
ds18b20.read(nil, nil, nil) -- discard first read

temp_f = nil
tmr.alarm(0, 10000, 1, function() 
  temp_f = ds18b20.read(nil, 'F', 10)
end);

handlers["/"] = function(s, params)
  local buf = "<h1>ESP8266 Web Server</h1>"
  buf = buf.."<p>The endpoint you want is: <a href=\"/temperature/\">/temperature/</a>"

  send_page(s, 200, buf)
end

handlers["/temperature/"] = function(s, params)
  local valid = "false"
  local temp = "-1.0"
--  local temp_f = ds18b20.read(nil, 'F', 10)
  if (temp_f ~= nil and temp_f < 1850) then
    temp = ""..(temp_f / 10).."."..(temp_f % 10)
    valid = "true"
  end

  s:send("HTTP/1.1 200 OK\r\nConnection: Close\r\nContent-Type: application/json\r\n\r\n")
  s:send("{\"temperature\": "..temp..", \"valid\": "..valid..", \"type\": \"ds18b20\"}\r\n")
end
