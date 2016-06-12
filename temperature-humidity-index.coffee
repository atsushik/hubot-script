#
#
#
# Commands:
#	不快指数 <気温> <湿度>

module.exports = (robot) ->
	index = -100
	msg = ""
	calculateIndex = (temperature, humidity) ->
  		index = 0.81*temperature + 0.01 * humidity * (0.99 * temperature - 14.3) + 46.3
		index
	explainIndex = (index) ->
		msg = ""
		if index <= 54
			msg = "寒い"
		else if index <= 59
			msg = "肌寒い"
		else if index <=64
			msg = "何も感じない"
		else if index <= 74
			msg = "快適な"
		else if index <= 79
			msg = "やや暑い"
		else if index <= 84
			msg = "暑くて汗が出る"
		else
			msg = "暑くてたまらない"
		msg
	robot.hear /不快指数 ([1-90][1-90])(度|℃|) ([1-90][1-90]+)(%|％|)/i, (res) ->
		t = res.match[1]
		h = res.match[3]
		index = calculateIndex(t,h)
		msg = "現在の不快指数は " + index
		res.send msg
		msg = "体感としては " + explainIndex(index) + " 感じです"
		res.send msg

