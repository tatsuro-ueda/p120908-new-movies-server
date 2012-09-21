loadDataFromServer = ->
	req = new XMLHttpRequest()
	
	req.addEventListener('readystatechange', ->
		if req.readyState is 4
			if req.status is 200
				result.innerHTML = req.responseText
	)
	req.open('GET', 
		'/new_movie?tag1=%E6%8A%80%E8%A1%93&tag2=technology', 
		true)
loadDataButton = document.getElementById('loadDataButton')
loadDataButton.addEventListener('click', loadDataFromServer, false)