var fs = require('fs');
var moment = require('moment');

fs.readFile(__dirname + '/' + process.argv[2], 'utf8', function(err, data) {
    if (err) throw err;

    console.log("version,date,day");

    var versions = [];
    var arr = data.split('\n');
    arr.forEach( function(line) {
        var dotIndex, splitIndex;
        var date, version;
        if (line !== '') {
            dotIndex = line.lastIndexOf('.');
            splitIndex = line.indexOf(' ', dotIndex);
            date = line.slice(splitIndex).trim();
            versions.push({
                'version': line.substring(0, splitIndex),
                'date': new Date(date)
            });
        }
    });

    compareDate = versions[0]['date'];

    versions.forEach( function(obj) {
        var duration;
        duration = moment.duration(obj['date'] - compareDate);
        
        console.log('"%s","%s",%d', obj['version'], moment(obj['date']).format('DD/MM/YYYY'), Math.floor(duration.asDays()));
    });
});
