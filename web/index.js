/**
 * Created by grant on 11/22/15.
 */
require('shelljs/global');
var crypto = require('crypto');
var express = require('express')
var bodyParser = require('body-parser')
var yaml = require('js-yaml');
var fs = require('fs');
var app = express();
var md5sum = crypto.createHash('md5');
var dgst;
var pillarData;
var writeLock = false; //kwikset
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({extended: false}))

// parse application/json
app.use(bodyParser.json())

app.post('/config', function (req, res) {
    md5sum = crypto.createHash('md5');
    var stuff = req.body
    if (stuff.haproxy != null) {
        console.log('appears to have an haproxy key')
        pillarData = stuff
    }

    res.setHeader('Content-Type', 'text/plain')
    res.write('you posted:\n')
    var pillar = yaml.dump(pillarData)
    console.log("the pillar data: " + pillar)
    md5sum.update(pillar)
    dgst = md5sum.digest('hex')
    if (!writeLock) {
        writeLock = true;
        fs.writeFile('/srv/pillar/example.sls', pillar, 'utf8', doReload);
        writeLock = false;
    } else {
        res.end("currently rendering another request");
    }
    res.end(dgst)
})
app.get('/config', function (req, res) {
    res.end(fs.readFileSync('/etc/haproxy/haproxy.conf'))
})
app.get('/vars', function (req, res) {
    res.end(fs.readFileSync('/srv/pillar/example.sls'))
})


var doReload = function () {
    if (!writeLock) {
        writeLock = true
        if (exec(' salt-call --pillar-root=/srv/pillar --local state.highstate ;').code !== 0) {
            writeLock = false
            echo('Error: maybe something went wrong in execution?');

            //  c('cd /etc/haproxy/; git reset --hard ')

        } else {
            writeLock = false
            echo("I think it worked")
//   exec('cd /etc/haproxy/; git rev-parse HEAD > /tmp/last.commit')
//   exec('cd /etc/haproxy/; git add haproxy.conf; git commit -m ' + dgst)
        }
    } else {
        console.log("trouble obtaining an exclusive lock on the template for rendering")
    }
}

var server = app.listen(3003, function () {
    var host = server.address().address;
    var port = server.address().port;

    console.log('config reloader http://%s:%s', host, port);
});
