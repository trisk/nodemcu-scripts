http_res = {
  [200] = "OK",
  [400] = "Bad Request",
  [404] = "Not Found",
}

handlers = {}

function send_page(c, code, body)
  local title = "ESP8266 Web Server"
  local res = http_res[code]
  if code ~= 200 then
    title = code .. " " .. res
  end
  c:send("HTTP/1.1 " .. code .. " " .. res .. "\r\nConnection: Close\r\nContent-Type: text/html\r\n\r\n")
  c:send("<!DOCTYPE html>\r\n<html><head><title>" .. title .. "</title></head><body>")
  if body ~= nil then
      c:send(body)
  else
      c:send("<h1>" .. title .. "</h1>")
  end
  c:send("</body></html>")
end

function handle_http(c, request)
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
    handlers[path](c, params)
  elseif handlers[path .. "/"] ~= nil then
    handlers[path .. "/"](c, params)
  else
    send_page(c, 404, nil)
  end

  c:close()
  return 0
end

srv = net.createServer(net.TCP, 30 * 60)
srv:listen(80, function(c)
  local console = 0

  function s_output(str)
    if c ~= nil then
      c:send(str)
    end
  end

  c:on("receive", function(c, l)
    if console == 0 then
      console = handle_http(c, l)
      if console == 0 then
        return
      end
      node.output(s_output, 0)
    end
    node.input(l)
  end)

  c:on("disconnection", function(c)
    if console then
      node.output(nil)
    end
    collectgarbage()
  end)
end)

