(function() {
  var loadDataButton, loadDataFromServer;

  loadDataFromServer = function() {
    var req;
    req = new XMLHttpRequest();
    req.addEventListener('readystatechange', function() {
      var result;
      if (req.readyState === 4) {
        if (req.status === 200 || req.status === 304) {
          result = document.getElementById('result');
          return result.innerHTML = req.responseText;
        }
      } else {
        return console.log('Error loading data...');
      }
    });
    req.open('GET', 'new_movie?tag1=技術&tag2=technology', false);
    return req.send();
  };

  loadDataButton = document.getElementById('loadDataButton');

  loadDataButton.addEventListener('click', loadDataFromServer, false);

}).call(this);
