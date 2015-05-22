var xml2js = require('xml2js');
var fs = require('fs');

var parser = new xml2js.Parser();

var getDataSummary = function(version) {

    var projectSummary,
        oo_design,
        NOM,
        LOC,
        WMC = 0,
        WMCv = 0,
        MVG = 0;

    var finalData = {};

    parser.parseString(fs.readFileSync(__dirname + '/analyze/' + version + '/cccc.xml', 'utf8'), function(err, result) {
        if (err) throw err;

        projectSummary = result.CCCC_Project.project_summary;
        ooDesign = result.CCCC_Project.oo_design;

        NOM = Number(projectSummary[0]['number_of_modules'][0]['$'].value);
        LOC = Number(projectSummary[0]['lines_of_code'][0]['$'].value);
        MVG = Number(projectSummary[0]['McCabes_cyclomatic_complexity'][0]['$'].value);

        ooDesign[0].module.forEach( function (module) {
            WMC += Number(module['weighted_methods_per_class_unity'][0]['$'].value);
            WMCv += Number(module['weighted_methods_per_class_visibility'][0]['$'].value);
        });

        finalData.version = version;
        finalData.NOM = NOM;
        finalData.LOC = LOC;
        finalData.WMC = WMC;
        finalData.WMCv = WMCv;
        finalData.MVG = MVG;

        //console.log(finalData);
        console.log('"%s",%d,%d,%d,%d,%d', version, NOM, LOC, WMC, WMCv, MVG);

    });
};


fs.readFile(__dirname + '/' + process.argv[2], 'utf8', function(err, data) {
    if (err) throw err;

    console.log("version,NOM,LOC,WMC,WMCv,MVG");

    var arr = data.split('\n');
    arr.forEach( function(version) {
        if (version !== '') {
            getDataSummary(version);
        }
    });
});
