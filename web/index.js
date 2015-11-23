/**
 * Created by grant on 11/22/15.
 */
require('shelljs/global');
var crypto = require('crypto');
var express = require('express')
var bodyParser = require('body-parser')
var yaml = require('js-yaml');
var fs   = require('fs');
var app = express();
var md5sum = crypto.createHash('md5');
var dgst ;
var pillarData;
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))

// parse application/json
app.use(bodyParser.json())

app.post('/config',function (req, res) {
  md5sum = crypto.createHash('md5');
  var stuff = req.body
  if(stuff.haproxy != null){
    console.log('appears to have an haproxy key')
     pillarData = stuff

  }

  res.setHeader('Content-Type', 'text/plain')
  res.write('you posted:\n')
  pillar = yaml.dump(pillarData)
  console.log("the pillar data: " + pillar)
  md5sum.update(pillar) 
  dgst = md5sum.digest('hex')
  fs.writeFile('/srv/pillar/example.sls', pillar, 'utf8', doReload);
  res.end(dgst)
})
app.get('/config',function (req, res) {
  res.end(fs.readFileSync('/etc/haproxy/haproxy.conf'))
})

var doReload = function() {
  if (exec(' salt-call --pillar-root=/srv/pillar --local state.highstate ;').code !== 0) {
    echo('Error: maybe something went wrong in execution?');
 //  c('cd /etc/haproxy/; git reset --hard ')
     
  }else{
    echo("I think it worked")
//   exec('cd /etc/haproxy/; git rev-parse HEAD > /tmp/last.commit')
//   exec('cd /etc/haproxy/; git add haproxy.conf; git commit -m ' + dgst)
 }

}

var server = app.listen(3003, function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('config reloader http://%s:%s', host, port);
});
