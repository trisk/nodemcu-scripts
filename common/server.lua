http_res = {
  [200] = "OK",
  [400] = "Bad Request",
  [404] = "Not Found",
}

handlers = {}

function send_page(s, code, body)
  local title = "ESP8266 Web Server"
  local res = http_res[code]
  if code ~= 200 then
    title = code .. " " .. res
  end
  s:send("HTTP/1.1 " .. code .. " " .. res .. "\r\nConnection: Close\r\nContent-Type: text/html\r\n\r\n")
  s:send("<!DOCTYPE html>\r\n<html><head><title>" .. title .. "</title></head><body>")
  if body ~= nil then
      s:send(body)
  else
      s:send("<h1>" .. title .. "</h1>")
  end
  s:send("</body></html>")
end

function handle_http(s, request)
  local params = {}
  local _, _, method, path, vars = string.find(request, "^(%a+)%s+([^?%s]+)(?*%S-)%s+HTTP")

  if method == nil then
    return 1
  end

  vars = vars:sub(2)
  for k, v in string.gmatch(vars, "([^&=%s]+)=([^&=%s]*)&*") do
    params[k] = v
  end

  if handlers[path] ~= nil then
    handlers[path](s, params)
  elseif handlers[path .. "/"] ~= nil then
    handlers[path .. "/"](s, params)
  else
    send_page(s, 404, nil)
  end

  s:close()
  return 0
end

srv = net.createServer(net.TCP, 30 * 60)
srv:listen(80, function(c)
  local console = nil

  function s_output(str)
    if console ~= nil then
      console:send(str)
    end
  end

  c:on("receive", function(s, l)
    if console == nil then
      if handle_http(s, l) then
        console = c
        node.output(s_output, 0)
      else
        return
      end
    end
    node.input(l)
  end)

  c:on("disconnection", function(s)
    if console then
      node.output(nil)
    end
    collectgarbage()
  end)
end)

