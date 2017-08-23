const exec = require('child_process').exec;
const fs = require('fs');

exports.handler = function(event, context, callback) {
  // In order to return a value and not deal with stdout rumbda watches a file.
  const jsonFilePath = '/tmp/rumbda.' + Math.random() + '.json';
  process.env['RUMBDA_RESULT_JSON_FILENAME'] = jsonFilePath;

  const child = exec('./ruby_wrapper ' + "'" +  JSON.stringify(event) + "'", (error, stdout, stderr) => {
    if (error) {
      callback(error);
      return;
    }

    if (fs.existsSync(jsonFilePath)) {
      fs.readFile(jsonFilePath, 'utf8', function (err, data) {
        fs.unlink(jsonFilePath); 

        if (err) {
          callback(err);
          return;
        }
        callback(null, (data.length > 0) ? JSON.parse(data) : null);
      });
    } else {
      callback(null);
    }
  });

  child.stdout.on('data', console.log);
  child.stderr.on('data', console.error);
};

