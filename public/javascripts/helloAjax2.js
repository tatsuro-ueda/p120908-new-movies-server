(function() {
  var loadDataButton, loadDataFromServer;

  loadDataFromServer = function() {
    var req;
    req = new XMLHttpRequest();
    req.addEventListener('readystatechange', function() {
      if (req.readyState === 4) {
        if (req.status === 200) {
          return result.innerHTML = req.responseText;
        }
      }
    });
    return req.open('GET', '/new_movie?tag1=%E6%8A%80%E8%A1%93&tag2=technology', true);
  };

  loadDataButton = document.getElementById('loadDataButton');

  loadDataButton.addEventListener('click', loadDataFromServer, false);

}).call(this);
