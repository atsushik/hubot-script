#
#
#
# Commands:
#   暖房を<temperature(18〜25)>度にして
#   暖房(を|)消して
#   暖房(を|)つけて

fs   = require 'fs'
path = require 'path'

module.exports = (robot) ->
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
  doControl = (func) ->
    msg = "暖房を#{func}にします"
    filePath = "/home/pi/git/irweb/data/sharp/ac-222fd/#{func}.json"
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
  robot.hear /暖房(を|)消して/i, (res) ->
    msg = doControl("off")
    res.send msg
  #
  robot.hear /暖房(を|)つけて/i, (res) ->
    msg = doHeating(18)
    res.send msg
  #
  robot.hear /暖房(を|)([12][1-90])度にして/i, (res) ->
    t = res.match[2]
    msg = doHeating(t)
    res.send msg
