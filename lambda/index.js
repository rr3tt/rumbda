const exec = require('child_process').exec;

exports.handler = function(event, context) {
  const child = exec('./ruby_wrapper ' + "'" +  JSON.stringify(event) + "'", (result) => {
    context.done(result);
  });

  child.stdout.on('data', console.log);
  child.stderr.on('data', console.error);
};
