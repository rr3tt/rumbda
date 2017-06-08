const exec = require('child_process').exec;

exports.handler = function(event, context) {
  var context = context;
  event['Records'].forEach(function(record) {
    const child = exec('./ruby_wrapper ' + "'" +  JSON.stringify(record) + "' '" + JSON.stringify(context) + "'", (result) => {
      context.done(result);
    });

    child.stdout.on('data', function (data) {
      data.split("\n").forEach(function(x) {
        console.log(x);
      });
    });
    child.stderr.on('data', function (data) {
      data.split("\n").forEach(function(x) {
        console.log(x);
      });
    });
  });
};
