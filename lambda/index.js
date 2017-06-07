const exec = require('child_process').exec;

exports.handler = function(event, context) {
  const child = exec('./ruby_wrapper ' + "'" +  JSON.stringify(event) + "' '" + JSON.stringify(context) + "'", (result) => {
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
};
