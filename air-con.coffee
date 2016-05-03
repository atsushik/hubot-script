#
#
#
# Commands:
#   (暖房|エアコン|冷房)を消して
#   エアコンを送風にして
#   暖房をつけて
#   暖房を<temperature(18〜25)>度にして
#   冷房を<temperature(20〜28)>度にして

fs   = require 'fs'
path = require 'path'

module.exports = (robot) ->
  doCooling = (temperature) ->
    msg = "冷房の設定温度を#{temperature}度にします"
    filePath = "/home/pi/git/irweb/data/sharp/ac-222fd/cool#{temperature}_Louver.json"
    try
      data = fs.readFileSync filePath, 'utf-8'
      if data
        console.log(data)
        robot.http("http://irweb_c5a2.local/messages")
        .header('Content-Type', 'application/json')
        .post(data) (err, res, body) ->
        if err
          return "Encountered an error :( #{err}"
        if res.statusCode isnt 200
          msg = "送信に失敗しました :("
        else
          msg = "送信に成功しました"
    catch error
        console.log('Unable to read file', error) unless error.code is 'ENOENT'
    msg
  #
  doHeating = (temperature) ->
    msg = "暖房の設定温度を#{temperature}度にします"
    filePath = "/home/pi/git/irweb/data/sharp/ac-222fd/warm#{temperature}_Louver2.json"
    try
      data = fs.readFileSync filePath, 'utf-8'
      if data
        console.log(data)
        robot.http("http://irweb_c5a2.local/messages")
        .header('Content-Type', 'application/json')
        .post(data) (err, res, body) ->
        if err
          return "Encountered an error :( #{err}"
        if res.statusCode isnt 200
          msg = "送信に失敗しました :("
        else
          msg = "送信に成功しました"
    catch error
        console.log('Unable to read file', error) unless error.code is 'ENOENT'
    msg
  #
  doControl = (func,name="エアコン", func_name="") ->
    if func_name.length == 0
      func_name = func;
    msg = "#{name}を#{func_name}にします"
    filePath = "/home/pi/git/irweb/data/sharp/ac-222fd/#{func}.json"
    console.log(filePath)
    try
      data = fs.readFileSync filePath, 'utf-8'
      if data
        console.log(data)
        robot.http("http://irweb_c5a2.local/messages")
        .header('Content-Type', 'application/json')
        .post(data) (err, res, body) ->
        if err
          return "Encountered an error :( #{err}"
        if res.statusCode isnt 200
          msg = "送信に失敗しました :("
        else
          msg = "送信に成功しました"
    catch error
        console.log('Unable to read file', error) unless error.code is 'ENOENT'
    msg
  #
  robot.hear /(エアコン)(を|)送風にして/i, (res) ->
    #msg = doControl("wind_auto", name=res.match[1], func_name="送風")
    msg = doControl("wind_Louver", name=res.match[1], func_name="送風")
    res.send msg
  #
  robot.respond /(暖房|エアコン|冷房)(を|)消して/i, (res) ->
    msg = doControl("off", name=res.match[1])
    res.send msg
  #
  robot.respond /暖房(を|)つけて/i, (res) ->
    msg = doHeating(18)
    res.send msg
  #
  robot.respond /暖房(を|)([12][1-90])度にして/i, (res) ->
    t = res.match[2]
    msg = doHeating(t)
    res.send msg
  #
  robot.respond /冷房(を|)つけて/i, (res) ->
    msg = doCooling(26)
    res.send msg
  #
  robot.respond /冷房(を|)([12][1-90])度にして/i, (res) ->
    t = res.match[2]
    msg = doCooling(t)
    res.send msg
