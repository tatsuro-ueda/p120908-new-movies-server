# XMLHttpRequest.coffee
loadDataFromServer = ->
	req = new XMLHttpRequest()

	req.addEventListener 'readystatechange', ->
		if req.readyState is 4                        # ReadyState Compelte
			if req.status is 200 or req.status is 304   # Success result codes
				result = document.getElementById('result')
				result.innerHTML = req.responseText
        # data = eval '(' + req.responseText + ')'
        # console.log 'data message: ', data.message
		else
			console.log 'Error loading data...'
　　
	req.open 'GET', 'new_movie?tag1=技術&tag2=technology', false
	req.send()

loadDataButton = document.getElementById 'loadDataButton'
loadDataButton.addEventListener 'click', loadDataFromServer, false