const exec = require('child_process').exec;
const fs = require('fs');

exports.handler = function(event, context, callback) {
  // In order to return a value and not deal with stdout rumbda watches a file.
  const jsonFilePath = '/tmp/rumbda.json';
  event['RUMBDA_RESULT_JSON_FILENAME'] = jsonFilePath;

  const child = exec('./ruby_wrapper ' + "'" +  JSON.stringify(event) + "'", (result) => {
    if (fs.existsSync(jsonFilePath)) {
      fs.readFile(jsonFilePath, 'utf8', function (err, data) {
        if (err) {
          fs.unlink(jsonFilePath); 
          return callback(err);
        }
        if (data.length > 0) {
          callback(null, JSON.parse(data));
        } else {
          callback(null, data);
        }

        fs.unlink(jsonFilePath); 
      });
    } else {
      callback(null, result);
    }
  });

  child.stdout.on('data', console.log);
  child.stderr.on('data', console.error);
};
