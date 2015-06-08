srv = net.createServer(net.TCP, 30 * 60);
srv:listen(23, function(c)
  function s_output(str)
    if c ~= nil then
      c:send(str)
    end
  end

  c:on("receive", function(c, l)
    node.input(l);
  end);

  c:on("disconnection", function(c)
    node.output(nil);
    collectgarbage();
  end);

  node.output(s_output, 0);
end);
